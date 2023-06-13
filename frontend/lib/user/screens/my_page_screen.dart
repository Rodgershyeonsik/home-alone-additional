import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forms/my_page_form.dart';
import '../../utility/size.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/logo.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
            appBar: CommonAppBar(title: "MY PAGE"),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: const [
                    SizedBox(height: small_gap,),
                    Logo(title: "내 정보",),
                    SizedBox(height: small_gap,),
                    MyPageForm(),
                  ],
                ),
              ),
          drawer: CustomDrawer()
        ),
    );
  }
}
