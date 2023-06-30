import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../utility/http_uri.dart';

class SpringMemberApi {
  static Future<bool?> emailCheck ( String email ) async {

    var response = await http.get(
      Uri.http(HttpUri.home, '/member/check-email/$email'),
    );

    if (response.statusCode == 200) {
      debugPrint("emailCheck 통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("emailCheck 통신 실패");
    }
  }

  static Future<bool?> nicknameCheck (String nickname) async {

    var response = await http.get(
      Uri.http(HttpUri.home, '/member/check-nickname/$nickname'),
    );

    if (response.statusCode == 200) {
      debugPrint("nicknameCheck 통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("nicknameCheck 통신 실패");
    }
  }

  static Future<bool?> signUp (MemberSignUpRequest request) async {
    var data = { 'email': request.email, 'password': request.password, 'nickname': request.nickname };
    var body = json.encode(data);

    debugPrint(request.email);
    debugPrint(request.password);
    debugPrint(request.nickname);
    debugPrint(body);

    var response = await http.post(
      Uri.http(HttpUri.home, '/member/sign-up'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("signUp 통신 확인");
      debugPrint("그냥 제이슨을 보자: " + response.body);

      return json.decode(response.body);
    } else {
      throw Exception("signUp 통신 실패");
    }
  }

  static Future<SignInResponse> signIn (MemberSignInRequest request) async {
    var data = { 'email': request.email, 'password': request.password };
    var body = json.encode(data);

    debugPrint("signIn request: " +  body);

    var response = await http.post(
      Uri.http(HttpUri.home, '/member/sign-in'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("로그인 통신 확인");
      debugPrint("signIn response: " + response.body);

      var uft8DecodedJsonRes = jsonDecode(utf8.decode(response.bodyBytes));


      return SignInResponse.fromJson(uft8DecodedJsonRes);
    } else {
      throw Exception("로그인 통신 실패: ${response.statusCode}");
    }
  }

  static Future<bool?> requestSignOut (String? userToken) async {
    var data = { 'userToken': userToken };
    var body = json.encode(data);

    var response = await http.post(
      Uri.http(HttpUri.home, '/member/sign-out'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("통신 실패. ${response.statusCode}");
    }
  }

  static Future<bool> requestModifyUserData (ChangeNicknameRequest request) async {
    var data = { 'userToken': request.userToken, 'newNickname' : request.newNickname };
    var body = json.encode(data);

    var response = await http.put(
      Uri.http(HttpUri.home, '/member/change-nickname'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("닉넴 변경 통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("닉변경 통신 실패");
    }
  }

  static Future<bool> requestUnregister (String? userToken) async {
    var data = { 'userToken': userToken };
    var body = json.encode(data);

    var response = await http.delete(
      Uri.http(HttpUri.home, '/member/unregister'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("통신 실패");
    }
  }

  static Future<bool> requestIfTokenIsValid(String token) async {
    var response = await http.get(Uri.http(HttpUri.home, 'member/check-token-valid'),
        headers: {'Cookie': 'token=$token'});

    if(response.statusCode == 200) {
      debugPrint("requestIfTokenIsValid 통신 완료");
      return jsonDecode(response.body);
    } else {
      debugPrint("상태 코드: ${response.statusCode}");
      debugPrint("에러 내용: ${response.body}");
      throw Exception('requestIfTokenIsValid 통신 실패');
    }
  }
}

class SignInResponse {

  String result;
  String email;
  String nickname;

  SignInResponse({required this.result, required this.email, required this.nickname });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      result: json["result"] as String,
      email: json["email"] as String,
      nickname: json["nickname"] as String
    );
  }
}

class MemberSignUpRequest {
  String email;
  String password;
  String nickname;

  MemberSignUpRequest(this.email, this.password, this.nickname);
}

class ChangeNicknameRequest {
  String userToken;
  String newNickname;

  ChangeNicknameRequest(this.userToken, this.newNickname);
}

class MemberSignInRequest {
  String email;
  String password;

  MemberSignInRequest(this.email, this.password);
}