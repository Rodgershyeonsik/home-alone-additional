import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultAlertDialog extends StatelessWidget {
  const ResultAlertDialog({Key? key, required this.alertMsg})
      : super(key: key);

  final String alertMsg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: const Text('알림'),
        content: Text(alertMsg),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('확인')
          )
        ]
    );
  }
}