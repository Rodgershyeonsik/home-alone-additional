
import 'package:flutter/cupertino.dart';
import 'package:frontend/board/api/spring_board_api.dart';

class BoardRegisterProvider extends ChangeNotifier {
  String _title = "";
  late String _writer;
  String _content = "";
  late String _category = "자유";
  late bool _isRegistered;

  void setTitle(String title) {
    print("setTitle....");
    _title = title;
  }

  void setWriter(String writer) {
    _writer = writer;
  }

  void setContent(String content) {
    _content = content;
  }

  void setCategory(String category) {
    _category = category;
  }

  void setDefaultValue() {
    _title = "";
    _content = "";
    _isRegistered = false;
    _category = "자유";
  }
  bool get isRegistered => _isRegistered;

  bool checkValidate() {
    if(_title.isNotEmpty && _content.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> requestRegister() async {
    var request = BoardRegisterRequest(_title, _writer, _content, _category);
    _isRegistered = await SpringBoardApi().requestBoardRegister(request);
  }
}