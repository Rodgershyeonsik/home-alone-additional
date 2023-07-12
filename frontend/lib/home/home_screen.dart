import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../board/widgets/board_list_view.dart';
import '../utility/custom_enums.dart';
import '../utility/providers/board_list_provider.dart';
import '../utility/providers/user_data_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<BoardListProvider>(context, listen: false).loadEveryBoards(0);
    Provider.of<UserDataProvider>(context, listen: false).setUserData();

    return Scaffold(
      appBar: const CommonAppBar(title: "HOME ALONE"),
      body: Consumer<BoardListProvider>(
          builder: (context, provider, widget) {
            return
              provider.isLoading ?
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
                  : !provider.errorOccurred ?
                        provider.boards.isNotEmpty ?
                          BoardListView(
                          boards: provider.boards,
                          listTitle: "전체 게시글 목록",
                          category: BoardCategory.all,)
                      : const Center(
                        child: Text("게시물이 존재하지 않습니다.")
                        )
            : const Center(
                child: Text("통신이 원활하지 않습니다.\n앱을 재실행해주세요.")
              );
          },
        ),
      drawer: const CustomDrawer(),
    );
  }
}
