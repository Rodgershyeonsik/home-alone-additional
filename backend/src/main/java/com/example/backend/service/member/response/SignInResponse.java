package com.example.backend.service.member.response;

import lombok.*;

@Data
@NoArgsConstructor
public class SignInResponse {
    private String result;
    private String email = "";
    private String nickname = "";
}
