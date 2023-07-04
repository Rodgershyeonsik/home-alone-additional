package com.example.backend.member.dto;

import lombok.*;

@ToString
@Getter
public class SignInResponse {
    private final String result;
    private final String email;
    private final String nickname;

    public SignInResponse(String result) {
        this.result = result;
        this.email = "";
        this.nickname = "";
    }

    public SignInResponse(String result, String email, String nickname) {
        this.result = result;
        this.email = email;
        this.nickname = nickname;
    }
}
