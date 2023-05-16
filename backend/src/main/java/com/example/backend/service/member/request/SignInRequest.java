package com.example.backend.service.member.request;

import lombok.*;

@Getter
@ToString
@RequiredArgsConstructor
public class SignInRequest {
    final private String email;
    final private String password;
}
