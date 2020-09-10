import 'package:flutter/material.dart';

class PillGesture extends StatelessWidget {
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Color pillColor;

  PillGesture({
    @required this.onVerticalDragStart,
    @required this.onVerticalDragUpdate,
    @required this.onVerticalDragEnd,
    @required this.pillColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              width: 35,
              height: 4,
              decoration: BoxDecoration(
                color: pillColor ?? Colors.black26,
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
