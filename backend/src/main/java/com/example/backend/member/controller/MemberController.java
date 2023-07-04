package com.example.backend.member.controller;

import com.example.backend.member.service.MemberService;
import com.example.backend.member.dto.FlutterUserTokenRequest;
import com.example.backend.member.dto.ChangeNicknameRequest;
import com.example.backend.member.dto.SignUpRequest;
import com.example.backend.member.dto.SignInRequest;
import com.example.backend.member.dto.MemberDataResponse;
import com.example.backend.member.dto.SignInResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/member")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class MemberController {

    @Autowired
    private MemberService service;

    @GetMapping("/check-email/{email}")
    public Boolean emailValidation(@PathVariable("email") String email) {
        log.info("emailValidation(): " + email);

        return service.emailValidation(email);
    }

    @GetMapping("/check-nickname/{nickname}")
    public Boolean nicknameValidation(@PathVariable("nickname") String nickname) {
        log.info("nicknameValidation(): " + nickname);

        return service.nicknameValidation(nickname);
    }

    @PostMapping("/sign-up")
    public Boolean signUp(@RequestBody SignUpRequest request) {
        log.info("signUp: " + request);

        return service.signUp(request);
    }

    @PostMapping("/sign-in")
    public SignInResponse signIn(@RequestBody SignInRequest request) {
        log.info("signIn: " + request);

        return service.signIn(request);
    }

    @PostMapping("/sign-out")
    public Boolean signOut(@RequestBody FlutterUserTokenRequest request) {
        log.info("signOutRequest: " + request);

        return service.signOut(request);
    }

    @PostMapping("/data-read")
    public MemberDataResponse readUserData(@RequestBody FlutterUserTokenRequest request) {
        log.info("readUserData: " + request);

        return service.userData(request);
    }

    @PutMapping("/change-nickname")
    public Boolean changeUserNickname(@RequestBody ChangeNicknameRequest request) {
        log.info("changeUserNickname: " + request);

        return service.changeUserNickname(request);
    }

    @DeleteMapping("/unregister")
    public Boolean removeMember(@RequestBody FlutterUserTokenRequest request) {
        log.info("removeMember: " + request);

        return service.removeMember(request);
    }

    @GetMapping("/check-token-valid")
    public Boolean checkTokenIsValid(@CookieValue("token")String token) {
        log.info("checkTokenIsValid() " + token);
        return service.checkTokenIsValid(token);
    }
}
