package com.example.backend.member.dto;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class ChangeNicknameRequest {
    private String userToken;
    private String newNickname;
}
