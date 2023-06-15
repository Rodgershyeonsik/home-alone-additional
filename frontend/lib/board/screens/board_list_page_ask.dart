import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/widgets/board_list_view.dart';
import 'package:frontend/utility/custom_enums.dart';
import 'package:provider/provider.dart';

import '../../utility/providers/board_list_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';

class BoardListPageAsk extends StatelessWidget {
  BoardListPageAsk({Key? key}) : super(key: key);

  late BoardListProvider _providerTest;

  @override
  Widget build(BuildContext context) {
    _providerTest = Provider.of<BoardListProvider>(context, listen: false);
    _providerTest.loadAskBoards();
    return Scaffold(
        appBar: CommonAppBar(title: "질문 게시판"),
        drawer: CustomDrawer(),
        body: Consumer<BoardListProvider>(
          builder: (context, provider, widget){
            if (provider.boards.isNotEmpty) {
              return BoardListView(
                boards: provider.boards,
                listTitle: "게시물 목록",
                category: BoardCategory.ask,);
            }
            return Center(
              child: Text("존재하는 게시물이 없습니다!"),
            );
          },
        )
    );
  }
}