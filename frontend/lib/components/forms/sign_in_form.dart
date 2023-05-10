import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/text_form_fields/text_form_field_email.dart';
import 'package:frontend/components/text_form_fields/text_form_field_password.dart';
import 'package:provider/provider.dart';

import '../../api/spring_member_api.dart';
import '../../utility/providers/login_data_provider.dart';
import '../../utility/secure_storage.dart';
import '../../utility/size.dart';
import '../custom_alert_dialog.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  static const String noEmail = "1";
  static const String incorrectPassword = "2";

  late SignInResponse _signInResponse;

  late String _email;
  late String _password;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 뭐지? 이거 왜있음?ㅋㅋㅋ
  late LoginDataProvider _loginDataProvider;

  @override
  void initState() {
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });

    _loginDataProvider = Provider.of<LoginDataProvider>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldEmail(controller: _emailController),
            const SizedBox(
              height: medium_gap,
            ),
            TextFormFieldPassword(controller: _passwordController),
            const SizedBox(
              height: medium_gap,
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && _loginDataProvider.loginState == false) {
                  _signInResponse = await SpringMemberApi()
                      .signIn(MemberSignInRequest(_email, _password));
                  if (_signInResponse.userToken.toString() == noEmail) {
                    showResultDialog(context, "로그인 실패!", "가입된 사용자 아님");
                  } else if (_signInResponse.userToken.toString() == incorrectPassword) {
                    showResultDialog(context, "로그인 실패!", "일치하지 않는 패스워드");
                  } else {
                    SecureStorage.storage.write(
                        key: 'login',
                        value: _signInResponse.userToken.toString());
                        _loginDataProvider.setUserToken(_signInResponse.userToken.toString());
                        _loginDataProvider.isLogin();

                    debugPrint("userToken after signin: " + _loginDataProvider.userToken.toString());
                    debugPrint("loginState after signin: " + _loginDataProvider.loginState.toString());

                    Navigator.pushNamed(context, "/home");
                  }
                } else if (_loginDataProvider.loginState == true) {
                  showResultDialog(context, "로그인 실패!", "이미 로그인 중입니다.");
                }
              },
              child: const Text("로그인"),
            ),
            const SizedBox(
              height: large_gap,
            ),
            TextButton(
              style: TextButton.styleFrom(
              backgroundColor: Colors.white),
                onPressed: (){
                  Navigator.pushNamed(context, "/sign-up");
                },
                child: const Text(
                    '아직 회원이 아니신가요?',
                    style: TextStyle(color: Colors.black)
                )
            ),
            // 이 위젯을 왜 썼더라?
            // RichText(
            //   text: TextSpan(children: [
            //     TextSpan(
            //         style: TextStyle(color: Colors.black),
            //         text: '아직 회원이 아니신가요?',
            //         recognizer: TapGestureRecognizer()
            //           ..onTap = () {
            //             Navigator.pushNamed(context, "/sign-up");
            //           }),
            //   ]),
            // )
          ],
        ));
  }

  void showResultDialog(BuildContext context, String title, String alertMsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(title: title, alertMsg: alertMsg));
  }
}
