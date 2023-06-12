package com.example.backend.service.member;

import com.example.backend.service.member.request.FlutterUserTokenRequest;
import com.example.backend.service.member.request.ChangeNicknameRequest;
import com.example.backend.service.member.request.SignUpRequest;
import com.example.backend.service.member.request.SignInRequest;
import com.example.backend.service.member.response.MemberDataResponse;
import com.example.backend.service.member.response.SignInResponse;

public interface MemberService {

    Boolean signUp(SignUpRequest request);
    Boolean emailValidation(String email);
    Boolean nicknameValidation(String nickname);
    SignInResponse signIn(SignInRequest request);

    Boolean signOut(FlutterUserTokenRequest request);

    MemberDataResponse userData(FlutterUserTokenRequest request);

    Boolean changeUserNickname(ChangeNicknameRequest request);

    Boolean removeMember(FlutterUserTokenRequest request);

}
