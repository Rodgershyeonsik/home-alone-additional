import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/logo.dart';
import '../forms/sign_in_form.dart';
import '../../utility/size.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "LOG IN PAGE"),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              SizedBox(height: xlarge_gap,),
              Logo(title: "로그인"),
              SizedBox(height: small_gap,),
              SignInForm(),
            ],
          ),
        ),
        drawer: CustomDrawer()
    );
  }
}