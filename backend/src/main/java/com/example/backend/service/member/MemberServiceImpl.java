package com.example.backend.service.member;

import com.example.backend.entity.board.Board;
import com.example.backend.entity.member.Authentication;
import com.example.backend.entity.member.BasicAuthentication;
import com.example.backend.entity.member.Member;
import com.example.backend.repository.AuthenticationRepository;
import com.example.backend.repository.BoardRepository;
import com.example.backend.repository.MemberRepository;
import com.example.backend.service.member.request.FlutterUserTokenRequest;
import com.example.backend.service.member.request.ChangeNicknameRequest;
import com.example.backend.service.member.request.SignUpRequest;
import com.example.backend.service.member.request.SignInRequest;
import com.example.backend.service.member.response.MemberDataResponse;
import com.example.backend.service.member.response.SignInResponse;
import com.example.backend.service.security.RedisService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@Transactional
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private AuthenticationRepository authenticationRepository;

    @Autowired
    private RedisService redisService;

    @Autowired
    private BoardRepository boardRepository;

    @Override
    public Boolean emailValidation(String email) {
        Optional<Member> maybeMember = memberRepository.findByEmail(email);

        return maybeMember.isEmpty();
    }

    @Override
    public Boolean nicknameValidation(String nickname) {
        Optional<Member> maybeMember = memberRepository.findByNickname(nickname);

        return maybeMember.isEmpty();
    }

    @Override
    public Boolean signUp(SignUpRequest request) {
        final Member member = request.toMember();
        memberRepository.save(member);

        final BasicAuthentication auth = new BasicAuthentication(member,
                Authentication.BASIC_AUTH, request.getPassword());

        authenticationRepository.save(auth);

        return true;
    }

    @Override
    public SignInResponse signIn(SignInRequest request) {
        SignInResponse signInResponse = new SignInResponse();

        final String EMAIL_DOES_NOT_EXIST = "email does not exist";
        final String INCORRECT_PASSWORD = "incorrect password";

        String email = request.getEmail();
        Optional<Member> maybeMember = memberRepository.findByEmail(email);

        if (maybeMember.isPresent()) {
            Member member = maybeMember.get();

            log.info("member email: " + member.getEmail());
            log.info("request email: " + request.getEmail());
            log.info("request password: " + request.getPassword());

            if (!member.isRightPassword(request.getPassword())) {
                log.info("패스워드 오류");
                signInResponse.setResult(INCORRECT_PASSWORD);
                return signInResponse;
            }

            UUID userToken = UUID.randomUUID();

            redisService.deleteByKey(userToken.toString());
            redisService.setKeyAndValue(userToken.toString(), member.getId());

            signInResponse.setResult(userToken.toString());
            signInResponse.setEmail(member.getEmail());
            signInResponse.setNickname(member.getNickname());

            return signInResponse;
        }
        log.info("가입된 사용자 아님");
        signInResponse.setResult(EMAIL_DOES_NOT_EXIST);

        return signInResponse;
    }

    @Override
    public Boolean signOut(FlutterUserTokenRequest request) {
        String requestToken = request.getUserToken();
        redisService.deleteByKey(requestToken);
        return true;
    }

    @Override
    public MemberDataResponse userData(FlutterUserTokenRequest request) {
        log.info("userToken: " + request.getUserToken());
        Long memberId = redisService.getValueByKey(request.getUserToken());

        log.info(memberId.toString());

        if (memberId != null) {
            Optional<Member> maybeMember = memberRepository.findById(memberId);
            if (maybeMember.isPresent()) {
                MemberDataResponse dataRes = new MemberDataResponse(maybeMember.get().getEmail(), maybeMember.get().getNickname());
                return dataRes;
            }
        }
        throw new RuntimeException("로그인 중인 사용자를 찾을 수 없음!");
    }

    @Override
    public Boolean changeUserNickname(ChangeNicknameRequest request) {
        Long memberId = redisService.getValueByKey(request.getUserToken());

        if (memberId != null) {
            Optional<Member> maybeMember = memberRepository.findById(memberId);

            if (maybeMember.isPresent()) {
                Member member = maybeMember.get();
                member.setNickname(request.getNewNickname());
                memberRepository.save(member);

                List<Board> usersBoards = maybeMember.get().getBoards();

                for (Board b : usersBoards) {
                    b.setWriter(request.getNewNickname());
                    boardRepository.save(b);
                }
                return true;
            } else {
                log.info("여기가 나오면 안되는딩? 세션은 있는데 멤버거 없음.");
                return false;
            }
        }

        log.info("로그인 세션 없음");
        return false;
    }

    @Override
    public Boolean removeMember(FlutterUserTokenRequest request) {
        Long memberId = redisService.getValueByKey(request.getUserToken());
        if (memberId != null) {

            final Optional<Authentication> maybeAuth = authenticationRepository.findByMemberId(memberId);
            if (maybeAuth.isPresent()) {
                authenticationRepository.deleteById(maybeAuth.get().getId());
            }

            List<Board> boards = boardRepository.findAllBoardsByMemberId(memberId, Sort.by(Sort.Direction.DESC, "boardNo"));

            for (Board b : boards) {
                boardRepository.deleteById(b.getBoardNo());
            }
            memberRepository.deleteById(memberId);
            return true;
        }
        throw new RuntimeException("로그인 중인 사용자를 찾을 수 없음!");
    }

    @Override
    public Boolean checkTokenIsValid(String token) {
        Long memberId = redisService.getValueByKey(token);
        if(memberId == null) {
            return false;
        }
        return true;
    }
}
