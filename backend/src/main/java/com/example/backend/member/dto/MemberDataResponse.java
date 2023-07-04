package com.example.backend.member.dto;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor

public class MemberDataResponse {
    String userEmail;
    String userNickname;
}
