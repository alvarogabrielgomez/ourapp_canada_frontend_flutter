import 'package:flutter/material.dart';

class Card2 extends StatelessWidget {
  Widget child;
  final double elevation;
  final Color color;
  Card2({@required this.child, this.elevation, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: elevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
