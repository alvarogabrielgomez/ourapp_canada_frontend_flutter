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
    var backgroundColor = color != null ? color : lightBtnBackground;
    Color _splashColor = darken(backgroundColor, 0.2).withAlpha(50);
    Color _highlightColor = darken(backgroundColor, 0.2).withAlpha(75);
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: _splashColor,
        focusColor: Colors.transparent,
        highlightColor: _highlightColor,
        child: Container(
          width: width,
          height: height,
          constraints: BoxConstraints(maxHeight: height),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
