import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utility/size.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/logo.dart';

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "HOME ALONE"),
        body: Container(
          padding: EdgeInsets.all(16),
            child: const Center(
              child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: small_gap,),
                  Logo(title: "회원 가입 완료",),
                  SizedBox(height: large_gap,),
                  Text("축하합니다! \n 회원 가입이 완료되었습니다!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  SizedBox(height: large_gap,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavigationButton(buttonText: "로그인", route:"/sign-in"),
                      SizedBox(width: small_gap,),
                      NavigationButton(buttonText: "홈화면", route:"/home"),
                    ],
                  )
                ],
              )
            )
        ),
    );
  }
}