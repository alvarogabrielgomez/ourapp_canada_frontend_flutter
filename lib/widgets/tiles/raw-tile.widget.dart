import 'package:flutter/material.dart';
import 'package:ourapp_canada/colors.dart';

class RawTile extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final Function onTap;
  RawTile(
      {Key key, this.child, this.color, this.width, this.height, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color _splashColor = darken(color, 0.2).withAlpha(50);
    Color _highlightColor = darken(color, 0.2).withAlpha(75);
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: color != null ? color : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        splashColor: _splashColor,
        focusColor: Colors.transparent,
        highlightColor: _highlightColor,
        child: Container(
          width: width,
          height: height,
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
