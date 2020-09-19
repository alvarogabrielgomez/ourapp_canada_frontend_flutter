import 'package:flutter/material.dart';
import 'package:ourapp_canada/colors.dart';

class CustomGridTile extends StatelessWidget {
  final Widget child;
  final Widget title;
  final Widget heroTitle;
  final Widget iconTile;
  final Color color;
  final Widget trailing;
  final Function onTap;
  final EdgeInsetsGeometry internalPadding;
  CustomGridTile(
      {Key key,
      this.child,
      this.color,
      @required this.onTap,
      this.title,
      this.iconTile,
      this.heroTitle,
      this.internalPadding,
      this.trailing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var backgroundColor = color != null ? color : lightBtnBackground;
    Color _splashColor = darken(backgroundColor, 0.2).withAlpha(50);
    Color _highlightColor = darken(backgroundColor, 0.2).withAlpha(75);
    var padding =
        internalPadding != null ? internalPadding : const EdgeInsets.all(26);
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
        child: Padding(
          padding: padding,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 23,
                left: 0,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 30,
                    maxHeight: 60,
                    minWidth: 100,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: heroTitle,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
                    heightFactor: 0.75,
                    child: Container(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: trailing,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 50,
                  height: 50,
                  child: iconTile,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 30,
                    maxHeight: 80,
                    minWidth: 100,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: title,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
