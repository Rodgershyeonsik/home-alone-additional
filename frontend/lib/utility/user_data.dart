import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api/spring_member_api.dart';

class UserData {
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  static String? authToken;
  static String? email;
  static String? nickname;

  static Future<void> setUserData() async {
    debugPrint("setUserData 시작");
    authToken = await storage.read(key: 'authToken');
    debugPrint("토큰 읽음");
    email = await storage.read(key: 'email');
    debugPrint("email 읽음");
    nickname = await storage.read(key: 'nickname');
    debugPrint("닉넴 읽음");
  }

  static Future<void> writeSignInResDataToStorage(SignInResponse response) async {
    await storage.write(key: 'authToken', value: response.result);
    await storage.write(key: 'email', value: response.email);
    await storage.write(key: 'nickname', value: response.nickname);
  }
}