import 'package:flutter/material.dart';
import 'package:frontend/utility/main_color.dart';

class RefreshFloatingButton extends StatefulWidget {
  const RefreshFloatingButton({super.key, required this.onPressEvent, required this.max});

  @override
  _RefreshFloatingButtonState createState() => _RefreshFloatingButtonState();
  final VoidCallback onPressEvent;
  final double max;
}

class _RefreshFloatingButtonState extends State<RefreshFloatingButton> {
  Offset _offset = Offset(350, 650);

  @override
  Widget build(BuildContext context) {
    double movedAmount = 0.0;

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
            feedback: FloatingActionButton(
              onPressed: (){},
              backgroundColor: MainColor.mainColor,
              child: Icon(Icons.refresh),
            ),
            onDragUpdate: (details) {
              movedAmount += details.delta.dy;
            },
            onDragEnd: (_) {
              var newDy = _offset.dy + movedAmount;
              if(newDy < 0) {
                newDy = 0.0;
              }

              if(newDy > widget.max) {
                newDy = widget.max;
              }

              setState(() {
                _offset = Offset(_offset.dx, newDy);
              });
            },
            )
          )
      ],
    );
  }
}
