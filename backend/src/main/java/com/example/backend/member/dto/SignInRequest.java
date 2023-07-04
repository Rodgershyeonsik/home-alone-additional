package com.example.backend.member.dto;

import lombok.*;

@Getter
@ToString
@RequiredArgsConstructor
public class SignInRequest {
    final private String email;
    final private String password;
}
