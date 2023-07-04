package com.example.backend.member.dto;

import com.example.backend.member.entity.Member;
import lombok.*;

@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor

public class SignUpRequest {
    private String email;
    private String password;
    private String nickname;

    public Member toMember () {
        return new Member( email, nickname );
    }
}
