import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/board/api/spring_board_api.dart';
import 'package:frontend/utility/custom_enums.dart';

import '../../board/api/board.dart';

class BoardListProvider extends ChangeNotifier{
  bool _isLoading = false;
  final List<Board> _boards = [];
  late int lastIndex;

  bool get isLoading => _isLoading;
  List<Board> get boards => _boards;
  bool errorOccurred = false;

  Future<void> loadEveryBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestAllBoardsWithPage(pageIndex);
    if(pagedBoardsRes == null) {
      errorOccurred = true;
      _isLoading = false;
      notifyListeners();
      return;
    }
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
    errorOccurred = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFreeBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestSpecificBoardWithPage("자유", pageIndex);
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAskBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestSpecificBoardWithPage("질문", pageIndex);
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecipeBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestSpecificBoardWithPage("1인분", pageIndex);
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNoticeBoards(int pageIndex) async {
    _isLoading = true;
    var pagedBoardsRes = await SpringBoardApi().requestSpecificBoardWithPage("공지", pageIndex);
    if(pageIndex == 0) {
      _boards.clear();
    }
    lastIndex = pagedBoardsRes.totalPages - 1;
    _boards.addAll(pagedBoardsRes.pagedBoards);
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