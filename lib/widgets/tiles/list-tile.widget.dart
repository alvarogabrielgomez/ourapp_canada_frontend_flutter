import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget child;
  final Widget title;
  final Widget iconTile;
  final Color color;
  final Function onTap;
  final EdgeInsetsGeometry internalPadding;

  CustomListTile(
      {Key key,
      this.child,
      this.color,
      @required this.onTap,
      this.title,
      this.iconTile,
      this.internalPadding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
