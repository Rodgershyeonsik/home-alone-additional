import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../utility/http_uri.dart';
import 'board.dart';

class SpringBoardApi{
  Future<void> requestBoardDelete(int boardNo) async {

    var response = await http.delete(
      Uri.http(HttpUri.home, '/board/$boardNo'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      debugPrint("게시물 삭제 통신 확인");
    } else {
      throw Exception("게시물 삭제 통신 실패");
    }
  }

  Future<Board> requestBoardModify(BoardModifyRequest request) async {
    var boardNo = request.boardNo;
    var data = { 'title': request.title, 'content' : request.content};
    var body = json.encode(data);

    var response = await http.put(
        Uri.http(HttpUri.home, '/board/$boardNo'),
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("게시물 수정 통신 확인");

      var jsonBoard = jsonDecode(utf8.decode(response.bodyBytes));
      Board responseBoard = Board.fromJson(jsonBoard);

      return responseBoard;
    } else {
      throw Exception("게시물 수정 통신 실패");
    }
  }

  Future<bool> requestBoardRegister(BoardRegisterRequest request) async {
    var data = { 'title': request.title, 'writer': request.writer,
                'content' : request.content, 'boardCategoryName' : request.boardCategoryName };
    var body = json.encode(data);

    var response = await http.post(
      Uri.http(HttpUri.home, '/board/register'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("게시물 등록 통신 확인");
      return json.decode(response.body);
    } else {
      throw Exception("게시물 등록 통신 실패");
    }
  }

  Future<PagedBoardRes> requestAllBoardsWithPage(int pageIndex) async {

    var response = await http.get(Uri.http(HttpUri.home, '/board/all-boards-with-page/$pageIndex'));

    if (response.statusCode == 200) {
      debugPrint("requestAllBoardsWithPage: " + utf8.decode(response.bodyBytes));
      var jsonPagedBoardRes = jsonDecode(utf8.decode(response.bodyBytes));

      var totalPages = jsonPagedBoardRes["totalPages"] as int;
      var jsonBoards = jsonPagedBoardRes["boards"] as List;

      List<Board> boards = jsonBoards.map((json)=>Board.fromJson(json)).toList();

      return PagedBoardRes(totalPages: totalPages, pagedBoards: boards);

    } else {
      throw Exception("board list 통신 실패");
    }
  }

  Future<PagedBoardRes> requestSpecificBoardWithPage(String categoryName, int pageIndex) async {
    debugPrint("카테고리: " + categoryName + ", index: " + pageIndex.toString());

    var response = await http.get(
        Uri.http(HttpUri.home, 'board/category-boards-with-page/$categoryName/$pageIndex')
    );

    if (response.statusCode == 200) {
      debugPrint("requestSpecificBoardList() 통신 확인");
      var jsonPagedBoardRes = jsonDecode(utf8.decode(response.bodyBytes));

      var totalPages = jsonPagedBoardRes["totalPages"] as int;
      var jsonBoards = jsonPagedBoardRes["boards"] as List;

      List<Board> boards = jsonBoards.map((json)=>Board.fromJson(json)).toList();

      return PagedBoardRes(totalPages: totalPages, pagedBoards: boards);
    } else {
      throw Exception("requestSpecificBoardList()통신 실패: " + response.statusCode.toString());
    }
  }
}

class BoardRegisterRequest {
  String title;
  String writer;
  String content;
  String boardCategoryName;

  BoardRegisterRequest(this.title, this.writer, this.content, this.boardCategoryName);
}

class BoardModifyRequest {
  int boardNo;
  String title;
  String content;

  BoardModifyRequest(this.boardNo, this.title, this.content);
}