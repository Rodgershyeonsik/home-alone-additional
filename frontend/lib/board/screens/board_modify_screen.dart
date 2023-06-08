import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/forms/board_modify_form.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../api/board.dart';

class BoardModifyScreen extends StatelessWidget {
  const BoardModifyScreen({Key? key, required this.board}) : super(key: key);
  final Board board;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: const CommonAppBar(title: "게시물 수정하기"),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BoardModifyForm(board: board)
          )
      ),
    );
  }
}