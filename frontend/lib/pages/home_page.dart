import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/forms/board_list_view.dart';
import '../components/custom_drawer.dart';
import '../components/custom_app_bar.dart';
import '../utility/providers/board_list_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<BoardListProvider>(context, listen: false).loadEveryBoards();

    return Scaffold(
      appBar: const CommonAppBar(title: "HOME ALONE"),
      body: Consumer<BoardListProvider>(
          builder: (context, provider, widget){
            if (provider.boards.isNotEmpty) {
              return BoardListView(boards: provider.boards, listTitle: "전체 게시글 목록",);
            }
            return const Center(
              child: Text("존재하는 게시물이 없습니다!"),
            );
          },
        ),
      drawer: const CustomDrawer(),
    );
  }
}
