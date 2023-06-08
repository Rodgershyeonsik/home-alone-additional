import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../forms/board_register_form.dart';

class BoardRegisterScreen extends StatelessWidget {
  const BoardRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(
          appBar: CommonAppBar(title: "게시물 작성하기"),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BoardRegisterForm()
          )
      ),
    );
  }
}