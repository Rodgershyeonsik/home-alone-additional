import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/logo.dart';
import '../forms/sign_up_form.dart';
import '../../utility/size.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: const CommonAppBar(title: "SIGN UP PAGE"),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: const [
                SizedBox(height: small_gap,),
                Logo(title: "회원 가입",),
                SizedBox(height: small_gap,),
                SignUpForm(),
              ],
            ),
          ),
        drawer: CustomDrawer()
      );
  }
}
