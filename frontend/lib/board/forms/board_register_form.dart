import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/api/spring_board_api.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:frontend/utility/providers/category_provider.dart';
import 'package:frontend/utility/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

import '../../utility/size.dart';
import '../../widgets/buttons/category_drop-down_btn.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/text_form_fields/text_form_field_for_board.dart';

class BoardRegisterForm extends StatefulWidget {
  const BoardRegisterForm({Key? key}) : super(key: key);

  @override
  State<BoardRegisterForm> createState() => _BoardRegisterFormState();
}

class _BoardRegisterFormState extends State<BoardRegisterForm> {

  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();

  late String title;
  late String writer;
  late String content;
  late String boardCategoryName;

  @override
  void initState() {
    titleController.addListener(() {
      title = titleController.text;
    });
    contentController.addListener(() {
      content = contentController.text;
    });

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    writer = Provider.of<UserDataProvider>(context, listen: false).nickname!;

    return Form(
        key: _formKey,
        child: Column(
          children: [
            const CategoryDropDownBtn(),
            TextFormFieldForBoard(use:"제목", maxLines:1, controller: titleController),
            SizedBox(height: small_gap,),
            TextFormFieldForBoard(use:"내용", maxLines:20, controller: contentController),
            SizedBox(height: small_gap,),
            Consumer<CategoryProvider>(
              builder: (context, category, child) {
                return LongButtonContainer(
                    textButton: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          boardCategoryName = category.category;
                          SpringBoardApi().requestBoardRegister(BoardRegisterRequest(title, writer, content, boardCategoryName));
                          category.setDefaultCategory();
                          moveToList(boardCategoryName);
                        } else {
                          showResultDialog(context, "게시물 등록 실패", "제목과 내용을 작성해주세요!");
                        }
                      },
                      child: Text("게시글 등록하기",
                      style: TextStyle(
                        color: Colors.white
                      ),)
                  ),
                );
              }
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

  void moveToList(String category) {
    if(category == "자유") {
      Navigator.pushNamed(context, "/board-list-free");
    } else if(category == "질문") {
      Navigator.pushNamed(context, "/board-list-ask");
    } else if(category == "1인분") {
      Navigator.pushNamed(context, "/board-list-recipe");
    }
  }
}