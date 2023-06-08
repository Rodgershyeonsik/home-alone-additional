import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/api/spring_board_api.dart';
import 'package:frontend/utility/custom_enums.dart';

import '../../board/api/board.dart';

class BoardListProvider extends ChangeNotifier{
  List<Board> _boards = [];
  List<Board> get boards => _boards;

  Future<void> loadEveryBoards() async {
    List<Board>? boardList = await SpringBoardApi().requestEveryBoardList();
    _boards = boardList!;
    notifyListeners();
  }

  Future<void> loadFreeBoards() async {
    List<Board>? boardList = await SpringBoardApi().requestSpecificBoardList("자유");
    _boards = boardList!;
    notifyListeners();
  }

  Future<void> loadAskBoards() async {
    List<Board>? boardList = await SpringBoardApi().requestSpecificBoardList("질문");
    _boards = boardList!;
    notifyListeners();
  }

  loadRecipeBoards() async {
    List<Board>? boardList = await SpringBoardApi().requestSpecificBoardList("1인분");
    _boards = boardList!;
    notifyListeners();
  }

  loadNoticeBoards() async {
    List<Board>? boardList = await SpringBoardApi().requestSpecificBoardList("공지");
    _boards = boardList!;
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
}