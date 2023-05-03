import 'package:flutter/material.dart';
import 'package:frontend/components/custom_alert_dialog.dart';
import 'package:frontend/components/text_form_fields/text_form_field_email.dart';
import 'package:frontend/components/text_form_fields/text_form_field_nickname.dart';
import 'package:frontend/components/text_form_fields/text_form_field_password.dart';
import 'package:frontend/components/text_form_fields/text_form_field_password_check.dart';

import '../../api/spring_member_api.dart';
import '../../utility/size.dart';
// TextEditingController를 쓰려면 stateful 써야 된다고 함..
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {

  late String _email;
  late String password;
  late String _nickname;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  late bool emailPass;
  late bool nicknamePass;
  late bool signUpSuccess;

  @override
  void initState() {
    _emailController.addListener(() {
      _email = _emailController.text;
    });
    _passwordController.addListener(() {
      password = _passwordController.text;
    });
    _nicknameController.addListener(() {
      _nickname = _nicknameController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldEmail(controller: _emailController,),
            const SizedBox(height: medium_gap,),
            TextButton(
              onPressed: () async {
                emailPass = await SpringMemberApi().emailCheck( _email );
                debugPrint('입력 이메일: ' + _email);
                debugPrint("emailPass: " + emailPass.toString());

                if(emailPass == true) {
                  showResultDialog(context, "이메일 중복 확인", "사용 가능한 이메일입니다.");
                  } else {
                  showResultDialog(context, "이메일 중복 확인", "중복 되는 이메일입니다.");
                }

              }, child: const Text("이메일 중복 확인"),
            ),
            const SizedBox(height: medium_gap,),
            TextFormFieldPassword(controller: _passwordController,),
            const SizedBox(height: medium_gap,),
            const TextFormFieldPasswordCheck(),
            const SizedBox(height: medium_gap,),
            TextFormFieldNickname(controller: _nicknameController,),
            const SizedBox(height: medium_gap,),
            TextButton(
              onPressed: () async {
                nicknamePass = await SpringMemberApi().nicknameCheck(_nickname);
                debugPrint("nicknamePass: " + nicknamePass.toString());

                if(nicknamePass == true) {
                  showResultDialog(context, "닉네임 중복 확인", "사용 가능한 닉네임입니다.");
                } else {
                  showResultDialog(context, "닉네임 중복 확인", "중복 되는 닉네임입니다.");
                }

              }, child: const Text("닉네임 중복 확인"),
            ),
            const SizedBox(height: medium_gap,),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if(emailPass == true && nicknamePass == true) {
                    signUpSuccess = await SpringMemberApi().signUp(MemberSignUpRequest(_email, password, _nickname));
                    if(signUpSuccess == true) {
                      Navigator.pushNamed(context, "/sign-up-complete");
                    }
                  } else if(emailPass == true && nicknamePass != true) {
                    showResultDialog(context, "유효하지 않은 값 확인", "닉네임 중복 여부를 확인하세요!");
                  } else if(emailPass != true && nicknamePass == true) {
                    showResultDialog(context, "유효하지 않은 값 확인", "이메일 중복 여부를 확인하세요!");
                  } else {
                    showResultDialog(context, "유효하지 않은 값 확인", "이메일, 닉네임 중복 여부를 확인하세요!");
                  }
                }
              },
              child: const Text("회원가입 하기"),
            )
          ],
        )
    );
  }

  void showResultDialog(BuildContext context, String title, String alertMsg) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(title: title, alertMsg: alertMsg)
      );
  }
}