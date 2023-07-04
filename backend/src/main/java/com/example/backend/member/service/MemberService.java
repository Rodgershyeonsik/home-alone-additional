package com.example.backend.member.service;

import com.example.backend.member.dto.FlutterUserTokenRequest;
import com.example.backend.member.dto.ChangeNicknameRequest;
import com.example.backend.member.dto.SignUpRequest;
import com.example.backend.member.dto.SignInRequest;
import com.example.backend.member.dto.MemberDataResponse;
import com.example.backend.member.dto.SignInResponse;

public interface MemberService {

    Boolean signUp(SignUpRequest request);
    Boolean emailValidation(String email);
    Boolean nicknameValidation(String nickname);
    SignInResponse signIn(SignInRequest request);

    Boolean signOut(FlutterUserTokenRequest request);

    MemberDataResponse userData(FlutterUserTokenRequest request);

    Boolean changeUserNickname(ChangeNicknameRequest request);

    Boolean removeMember(FlutterUserTokenRequest request);

    Boolean checkTokenIsValid(String token);
}
