
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/providers/board_register_provider.dart';
import 'package:frontend/utility/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

import '../../utility/size.dart';
import '../../widgets/buttons/category_drop-down_btn.dart';
import '../../widgets/text_form_fields/text_form_field_for_board.dart';

class BoardRegisterForm extends StatefulWidget {
  const BoardRegisterForm({Key? key}) : super(key: key);

  @override
  State<BoardRegisterForm> createState() => _BoardRegisterFormState();
}

class _BoardRegisterFormState extends State<BoardRegisterForm> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late BoardRegisterProvider boardRegisterProvider;

  @override
  void initState() {
    boardRegisterProvider = Provider.of<BoardRegisterProvider>(context, listen: false);
    titleController.addListener(() {
      boardRegisterProvider.setTitle(titleController.text);
    });
    contentController.addListener(() {
      boardRegisterProvider.setContent(contentController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var writer = Provider.of<UserDataProvider>(context, listen: false).nickname!;
    boardRegisterProvider.setWriter(writer);

    return Form(
        key: _formKey,
        child: Column(
          children: [
            const CategoryDropDownBtn(),
            TextFormFieldForBoard(use:"제목", maxLines:1, controller: titleController),
            const Divider(color: Colors.grey,),
            const SizedBox(height: small_gap,),
            TextFormFieldForBoard(use:"내용", maxLines:20, controller: contentController),
          ],
        )
      );
  }
}