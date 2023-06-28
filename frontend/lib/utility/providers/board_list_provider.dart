import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/api/spring_board_api.dart';
import 'package:frontend/utility/custom_enums.dart';

import '../../board/api/board.dart';

class BoardListProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<Board> _boards = [];
  late int lastIndex;

  bool get isLoading => _isLoading;
  List<Board> get boards => _boards;

  Future<void> loadEveryBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestAllBoardsWithPage(pageIndex);
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFreeBoards() async {
    _isLoading = true;
    _boards = await SpringBoardApi().requestSpecificBoardList("자유");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAskBoards() async {
    _isLoading = true;
    _boards = await SpringBoardApi().requestSpecificBoardList("질문");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecipeBoards() async {
    _isLoading = true;
    _boards = await SpringBoardApi().requestSpecificBoardList("1인분");
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNoticeBoards() async {
    _isLoading = true;
    _boards = await SpringBoardApi().requestSpecificBoardList("공지");
    _isLoading = false;
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