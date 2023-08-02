import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:frontend/utility/providers/board_register_provider.dart';
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
    return Scaffold(
      appBar: const CommonAppBar(title: "게시물 작성하기"),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: BoardRegisterForm()),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: LongButtonContainer(
          textButton: TextButton(
            onPressed: () async {
              var isValidated = boardRegisterProvider.checkValidate();
              if (isValidated) {
                await boardRegisterProvider.requestRegister();
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const ResultAlertDialog(
                        alertMsg: "제목과 내용을 모두 작성해주세요."));
              }
              if(boardRegisterProvider.isRegistered) {
                boardRegisterProvider.setDefaultValue();
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: Text("알림"),
                        content: Text("게시물 등록이 완료되었습니다."),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/home');
                              }, child: Text("확인"))
                        ],
                      )
                );
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
