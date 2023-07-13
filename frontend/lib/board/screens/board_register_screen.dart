import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:frontend/utility/providers/board_register_provider.dart';
import 'package:frontend/utility/providers/category_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/result_alert_dialog.dart';
import '../forms/board_register_form.dart';

class BoardRegisterScreen extends StatelessWidget {
  const BoardRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boardRegisterProvider =
        Provider.of<BoardRegisterProvider>(context, listen: false);
    var categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    return Scaffold(
      appBar: CommonAppBar(title: "게시물 작성하기"),
      drawer: CustomDrawer(),
      body: GestureDetector(
        onTap: () {
          print("제스쳐 감지");
          // FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16), child: BoardRegisterForm()),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(16),
        child: LongButtonContainer(
          textButton: TextButton(
            onPressed: () {
              var isValidated = boardRegisterProvider.checkValidate();
              if (isValidated) {
                boardRegisterProvider.requestRegister();
                categoryProvider.setDefaultCategory();
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const ResultAlertDialog(
                        alertMsg: "제목과 내용을 모두 작성해주세요."));
              }
            },
            child: Text(
              "게시물 등록하기",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
