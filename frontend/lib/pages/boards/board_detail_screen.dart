import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:provider/provider.dart';

import '../../api/board.dart';
import '../../utility/providers/user_data_provider.dart';
import 'board_modify_screen.dart';

class BoardDetailScreen extends StatelessWidget {
  const BoardDetailScreen({Key? key, required this.board}) : super(key: key);
  final Board board;

  @override
  Widget build(BuildContext context) {
    var nickname = Provider.of<UserDataProvider>(context, listen: false).nickname;

    return Scaffold(
      appBar: AppBar(
        title: Text(board.categoryName + " 게시판"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: TextStyle(fontSize: 25),
                maxLines: 2,
              ),
              const SizedBox(height: 10.0),
              Text(board.writer,
                style: const TextStyle(
                    fontSize: 17),),
              const SizedBox(height: 10.0,),
              Text(board.regDate.substring(0, 10),
                style: const TextStyle(fontSize: 15),),
              const SizedBox(height: 5.0,),
              nickname == board.writer ?
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardModifyScreen(board: board),
                        ),
                      );
                    },
                    child: const Text("수정",
                      style: TextStyle(
                          color: Colors.grey,
                        fontSize: 13.0
                      ),
                    )
                ),
              )
                  : const SizedBox.shrink(),
              const Divider(thickness: 1.5,),
              Text( board.content,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 15,)
              ),
              const SizedBox(height: 100.0,),
              LongButtonContainer(
                textButton: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("목록으로 돌아가기",
                    style: TextStyle(
                      color: Colors.white
                    ),)
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}