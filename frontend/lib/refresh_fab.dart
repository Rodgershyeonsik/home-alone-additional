import 'package:flutter/material.dart';
import 'package:frontend/utility/main_color.dart';

class RefreshFloatingButton extends StatefulWidget {
  const RefreshFloatingButton({super.key, required this.onPressEvent});

  @override
  _RefreshFloatingButtonState createState() => _RefreshFloatingButtonState();
  final VoidCallback onPressEvent;
}

class _RefreshFloatingButtonState extends State<RefreshFloatingButton> {
  Offset _offset = Offset(350, 650);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Draggable(
            axis: Axis.vertical,
            child: FloatingActionButton(
              onPressed: widget.onPressEvent,
              backgroundColor: MainColor.mainColor,
              child: Icon(Icons.refresh),
            ),
            childWhenDragging: SizedBox.shrink(),
            onDragUpdate: (details){
              print('local position: ' + details.localPosition.toString());
            },
            feedback: FloatingActionButton(
              onPressed: (){},
              backgroundColor: MainColor.mainColor,
              child: Icon(Icons.refresh),
            ),
            onDragEnd: (details) {
              setState(() {
                _offset = details.offset;
                print("offset: " + _offset.toString());
              });
            },
          ),
        ),
      ],
    );
  }
}
