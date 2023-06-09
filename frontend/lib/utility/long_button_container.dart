import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_color.dart';

class LongButtonContainer extends StatelessWidget {
  const LongButtonContainer({
    Key? key,
    required this.textButton
  }) : super(key: key);

  final TextButton textButton;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: MainColor.mainColor,
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: textButton
    );
  }
}
