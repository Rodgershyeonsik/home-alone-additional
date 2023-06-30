import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/auth/api/spring_member_api.dart';

class UserDataProvider extends ChangeNotifier {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  String? _authToken;
  String? _email;
  String? _nickname;
  late bool _isLogin;

  String? get authToken => _authToken;
  String? get email => _email;
  String? get nickname => _nickname;
  bool get isLogin => _isLogin;

  Future<void> setUserData() async {
    debugPrint("setUserData 시작");
    _authToken = await storage.read(key: 'authToken');
    debugPrint("토큰: " + _authToken.toString());
    if(_authToken != null) {
      _isLogin = await checkIfTokenIsValid(_authToken);
    } else {
      _isLogin = false;
      return;
    }
    if(_isLogin) {
      _email = await storage.read(key: 'email');
      debugPrint("email: " + _email.toString());
      _nickname = await storage.read(key: 'nickname');
      debugPrint("닉넴: " + _nickname.toString());
    } else {
      debugPrint("만료된 토큰. storage 유저 데이터 삭제.");
     await storage.deleteAll();
    }
  }

  Future<bool> checkIfTokenIsValid(token) async {
    return await SpringMemberApi.requestIfTokenIsValid(token);
  }

  void changeNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLogin = false;
    await SpringMemberApi.requestSignOut(_authToken);
    await UserDataProvider.storage.deleteAll();
    notifyListeners();
  }

  static Future<void> writeSignInResDataToStorage(SignInResponse response) async {
    await storage.write(key: 'authToken', value: response.result);
    await storage.write(key: 'email', value: response.email);
    await storage.write(key: 'nickname', value: response.nickname);
  }
}