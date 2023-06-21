import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/widgets/board_list_view.dart';
import 'package:frontend/utility/custom_enums.dart';
import 'package:provider/provider.dart';

import '../../utility/providers/board_list_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';

class NoticeBoardScreen extends StatelessWidget {
  NoticeBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<BoardListProvider>(context, listen: false).loadNoticeBoards();
    return Scaffold(
        appBar: CommonAppBar(title: "공지사항"),
        drawer: CustomDrawer(),
        body: Consumer<BoardListProvider>(
          builder: (context, provider, widget){
            return provider.isLoading ?
              const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  )
              )
              : provider.boards.isNotEmpty ?
                  BoardListView(
                    boards: provider.boards,
                    listTitle: "게시물 목록",
                    category: BoardCategory.notice)
                  : const Center(
                    child: Text("존재하는 게시물이 없습니다!"),
                  );
          },
        )
    );
  }
}