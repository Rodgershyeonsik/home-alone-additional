import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/text_form_fields/text_form_field_email.dart';
import 'package:frontend/components/text_form_fields/text_form_field_password.dart';

import '../../api/spring_member_api.dart';
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

  String? _signInResponse;

  late String _email;
  late String _password;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
    });

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
                if(!_formKey.currentState!.validate()) {
                  showResultDialog(context, '알림', '모두 유효한 값을 입력하세요!');
                  return;
                }

                _signInResponse = await SpringMemberApi().
                                  signIn(MemberSignInRequest(_email, _password));

                if(_signInResponse != null) {
                  switch(_signInResponse) {
                    case noEmail:
                      showResultDialog(context, "로그인 실패!", "가입된 사용자 아님");
                      break;
                    case incorrectPassword:
                      showResultDialog(context, "로그인 실패!", "비밀번호가 일치하지 않습니다.");
                      break;
                    default:
                      storage.write(
                                  key: 'authToken',
                                  value: _signInResponse);
                              Navigator.pushNamed(context, "/home");
                  }
                }
              },
              child: const Text("로그인"),
            ),
            const SizedBox(
              height: large_gap,
            ),
            RichText(
              text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: '아직 회원이 아니신가요?',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, "/sign-up");
                      }),
              ),
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
