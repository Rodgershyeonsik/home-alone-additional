package com.example.backend.member.service;

import com.example.backend.board.entity.Board;
import com.example.backend.security.entity.Authentication;
import com.example.backend.security.entity.BasicAuthentication;
import com.example.backend.member.entity.Member;
import com.example.backend.security.repository.AuthenticationRepository;
import com.example.backend.board.repository.BoardRepository;
import com.example.backend.member.repository.MemberRepository;
import com.example.backend.member.dto.FlutterUserTokenRequest;
import com.example.backend.member.dto.ChangeNicknameRequest;
import com.example.backend.member.dto.SignUpRequest;
import com.example.backend.member.dto.SignInRequest;
import com.example.backend.member.dto.MemberDataResponse;
import com.example.backend.member.dto.SignInResponse;
import com.example.backend.security.service.RedisService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        final String EMAIL_DOES_NOT_EXIST = "email does not exist";
        final String INCORRECT_PASSWORD = "incorrect password";

        Optional<Member> maybeMember = memberRepository.findByEmail(request.getEmail());
        if (maybeMember.isPresent()) {
            Member member = maybeMember.get();
            if (!member.isRightPassword(request.getPassword())) {
                return new SignInResponse(INCORRECT_PASSWORD);
            }

            UUID userToken = UUID.randomUUID();
            redisService.deleteByKey(userToken.toString());
            redisService.setKeyAndValue(userToken.toString(), member.getId());

            return new SignInResponse(userToken.toString(), member.getEmail(), member.getNickname());
        }
        log.info("가입된 사용자 아님");
        return new SignInResponse(EMAIL_DOES_NOT_EXIST);
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
                log.info("여기가 나오면 안되는딩? 세션은 있는데 멤버 없음.");
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
