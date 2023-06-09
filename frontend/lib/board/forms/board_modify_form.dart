import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/result_alert_dialog.dart';
import '../../widgets/text_form_fields/text_form_field_for_board.dart';
import '../api/board.dart';
import '../api/spring_board_api.dart';
import '../screens/board_detail_screen.dart';
import '../../utility/long_button_container.dart';
import '../../utility/size.dart';

class BoardModifyForm extends StatefulWidget {
  const BoardModifyForm({Key? key, required this.board}) : super(key: key);
  final Board board;
  @override
  State<BoardModifyForm> createState() => _BoardModifyFormState();
}

class _BoardModifyFormState extends State<BoardModifyForm> {

  late TextEditingController titleController = TextEditingController(text: widget.board.title);
  late TextEditingController contentController = TextEditingController(text: widget.board.content);

  late int boardNo;
  late String category;
  late String title;
  late String writer;
  late String content;

  late Board responseBoard;

  @override
  void initState() {
    titleController.addListener(() {
      title = titleController.text;
    });
    contentController.addListener(() {
      content = contentController.text;
    });
    writer = widget.board.writer;
    boardNo = widget.board.boardNo;
    category = widget.board.categoryName;

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

    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormFieldForBoard(use:"제목", maxLines:1, controller: titleController),
            SizedBox(height: small_gap,),
            TextFormFieldForBoard(use:"내용", maxLines:20, controller: contentController),
            SizedBox(height: small_gap,),
            LongButtonContainer(
              textButton: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      responseBoard = await SpringBoardApi().requestBoardModify(BoardModifyRequest(boardNo, title, content));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardDetailScreen(board: responseBoard),
                        ),
                      );
                    } else {
                      showDialog( context: context,
                        builder: (BuildContext context) =>
                            const ResultAlertDialog(alertMsg: "제목과 내용을 모두 입력해주세요.")
                      );
                    }
                  },
                  child: Text("게시글 수정하기",
                    style: TextStyle(
                        color: Colors.white
                    ),)
              ),
            ),
            SizedBox(height: small_gap,),
            LongButtonContainer(
              textButton: TextButton(
                  onPressed: () async {
                    await SpringBoardApi().requestBoardDelete(boardNo);
                    moveToList(category);
                  },
                  child: Text("게시글 삭제하기",
                    style: TextStyle(
                        color: Colors.white
                    ),)
              ),
            )],
        )
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
