import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/providers/board_register_provider.dart';
import 'package:frontend/utility/providers/category_provider.dart';
import 'package:frontend/utility/main_color.dart';
import 'package:provider/provider.dart';

class CategoryDropDownBtn extends StatefulWidget {
  const CategoryDropDownBtn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryDropDownBtnState();
}

class _CategoryDropDownBtnState extends State<CategoryDropDownBtn> {
  List<String> categoryList = <String>['자유', '질문', '1인분'];
  late String dropdownValue = categoryList[0];
  late CategoryProvider _categoryProvider;

  @override
  Widget build(BuildContext context) {
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    var boardRegisterProvider = Provider.of<BoardRegisterProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            color: MainColor.mainColor,
            borderRadius: BorderRadius.all( Radius.circular(5.0))),
          padding: EdgeInsets.all(1.0),
          child: Text("게시판 선택",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
      SizedBox(width: 20),
      DropdownButton<String>(
        value: dropdownValue,
        elevation: 16,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
            debugPrint(dropdownValue);
          });
          _categoryProvider.categorySelected(dropdownValue);
          boardRegisterProvider.setCategory(dropdownValue);
        },
        items: categoryList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ],
    );
  }

}