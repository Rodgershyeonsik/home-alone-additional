package com.example.backend.service.member.request;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class ChangeNicknameRequest {
    private String userToken;
    private String newNickname;
}
