import 'package:flutter/material.dart';
import 'package:ourapp_canada/widgets/tiles/raw-tile.widget.dart';

class MainTile extends StatefulWidget {
  final Color color;
  final double width;
  final Function onTap;
  final Widget iconTile;
  final Widget title;
  final Widget trailing;
  MainTile(
      {Key key,
      this.color,
      this.width,
      this.onTap,
      this.iconTile,
      this.title,
      this.trailing})
      : super(key: key);
  @override
  _MainTileState createState() => _MainTileState();
}

class _MainTileState extends State<MainTile> {
  @override
  Widget build(BuildContext context) {
    return RawTile(
      color: widget.color,
      height: 180,
      width: widget.width,
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 27,
        ),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: widget.iconTile,
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
                    child: widget.title,
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
                        child: widget.trailing,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
