package com.example.backend.service.member;

import com.example.backend.service.member.request.FlutterUserTokenRequest;
import com.example.backend.service.member.request.MemberModifyRequest;
import com.example.backend.service.member.request.SignUpRequest;
import com.example.backend.service.member.request.SignInRequest;
import com.example.backend.service.member.response.MemberDataResponse;
public interface MemberService {

    Boolean signUp(SignUpRequest request);
    Boolean emailValidation(String email);
    Boolean nicknameValidation(String nickname);
    String signIn(SignInRequest request);

    Boolean signOut(FlutterUserTokenRequest request);

    MemberDataResponse userData(FlutterUserTokenRequest request);

    Boolean modifyUserData(MemberModifyRequest request);

    Boolean removeMember(FlutterUserTokenRequest request);

}
