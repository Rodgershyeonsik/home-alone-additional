import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/custom_app_bar.dart';
import 'package:frontend/components/custom_drawer.dart';
import 'package:frontend/components/forms/board_modify_form.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:provider/provider.dart';

import '../../api/board.dart';
import '../../utility/providers/user_data_provider.dart';

class BoardDetailPage extends StatelessWidget {
  const BoardDetailPage({Key? key, required this.board}) : super(key: key);
  final Board board;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppBar(title: board.categoryName + " 게시판"),
      drawer: CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row( children: [
              Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    // color: Colors.tealAccent,
                    padding: EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          board.title,
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(height: 10.0),
                        Text(board.regDate.substring(0, 10),
                          style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  )
              ),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child:  Container(
                    padding: EdgeInsets.all(10.0),
                    // height: 80,
                    // color: Colors.blueGrey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 40,),
                        Text( board.writer,
                          style: TextStyle(fontSize: 15),),
                      ],),
                  )
              )
            ],
            ),
            Divider(thickness: 1.5,),
            Container(
                padding: EdgeInsets.all(10.0),
                width: 200,
                height: 500,
                child: Text( board.content,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15,)
                )
            ),
            LongButtonContainer(
              textButton: TextButton(
                  onPressed: () {
                    moveToList(context, board.categoryName);
                  },
                  child: Text("목록으로 돌아가기",
                  style: TextStyle(
                    color: Colors.white
                  ),)
              ),
            ),
            Visibility(
                visible: Provider.of<UserDataProvider>(context,listen: false).nickname == board.writer ? true : false, // board.writer == 로그인 유저 닉네임 이런 식으로 줄 예정(?)
                child: LongButtonContainer(
                  textButton: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardModifyForm(board: board),
                          ),
                        );
                      },
                      child: Text("게시물 수정하기",
                      style: TextStyle(
                        color: Colors.white
                      ),)
                  ),
                ))
          ],
        )
      )
    );
  }
  void moveToList(BuildContext context, String category) {
    if(category == "자유") {
      Navigator.pushNamed(context, "/board-list-free");
    } else if(category == "질문") {
      Navigator.pushNamed(context, "/board-list-ask");
    } else if(category == "1인분") {
      Navigator.pushNamed(context, "/board-list-recipe");
    }
  }
}