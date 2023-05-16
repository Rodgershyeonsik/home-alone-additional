package com.example.backend;

import com.example.backend.service.member.MemberService;
import com.example.backend.service.member.request.SignInRequest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class MemberSignInTestCase {
    @Autowired
    private MemberService service;

    @Test
    void memberSignInTest() {
        SignInRequest signInRequest = new SignInRequest("test5@gmail.com", "test5");

        System.out.println("signInResult: " + service.signIn(signInRequest));
    }
}
