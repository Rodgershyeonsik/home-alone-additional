import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/api/spring_board_api.dart';
import 'package:frontend/utility/custom_enums.dart';

import '../../board/api/board.dart';

class BoardListProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<Board> _boards = [];

  bool get isLoading => _isLoading;
  List<Board> get boards => _boards;

  Future<void> loadEveryBoards() async {
    _isLoading = true;
    _boards = await SpringBoardApi().requestEveryBoardList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFreeBoards() async {
    _boards = await SpringBoardApi().requestSpecificBoardList("자유");
    notifyListeners();
  }

  Future<void> loadAskBoards() async {
    _boards = await SpringBoardApi().requestSpecificBoardList("질문");
    notifyListeners();
  }

  Future<void> loadRecipeBoards() async {
    _boards = await SpringBoardApi().requestSpecificBoardList("1인분");
    notifyListeners();
  }

  Future<void> loadNoticeBoards() async {
    _boards = await SpringBoardApi().requestSpecificBoardList("공지");
    notifyListeners();
  }

  void sortBoard(SortBy sortBy) {
    if(sortBy == SortBy.earliest) {
      _boards.sort((a,b)=> a.boardNo.compareTo(b.boardNo));
      notifyListeners();
    }

    if(sortBy == SortBy.latest) {
      _boards.sort((a,b)=> b.boardNo.compareTo(a.boardNo));
      notifyListeners();
    }
  }

  void forceLoading() {
    print('로딩 강제');
    _isLoading = true;
    notifyListeners();
  }
}