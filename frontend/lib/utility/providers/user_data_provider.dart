import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api/spring_member_api.dart';

class UserDataProvider extends ChangeNotifier {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  String? _authToken;
  String? _email;
  String? _nickname;

  String? get authToken => _authToken;
  String? get email => _email;
  String? get nickname => _nickname;

  Future<void> setUserData() async {
    debugPrint("setUserData 시작");
    _authToken = await storage.read(key: 'authToken');
    debugPrint("토큰 읽음");
    _email = await storage.read(key: 'email');
    debugPrint("email 읽음");
    _nickname = await storage.read(key: 'nickname');
    debugPrint("닉넴 읽음");
  }

  void changeNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  static Future<void> writeSignInResDataToStorage(SignInResponse response) async {
    await storage.write(key: 'authToken', value: response.result);
    await storage.write(key: 'email', value: response.email);
    await storage.write(key: 'nickname', value: response.nickname);
  }
}