import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './pill_gesture.dart';

class SlideDialog extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color pillColor;
  final maxHeight;

  SlideDialog({
    @required this.child,
    @required this.pillColor,
    @required this.backgroundColor,
    @required this.maxHeight,
  });

  @override
  _SlideDialogState createState() => _SlideDialogState();
}

class _SlideDialogState extends State<SlideDialog> {
  var _initialPosition = 0.0;
  var _currentPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.only(
              top: (deviceHeight - widget.maxHeight) + _currentPosition),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: Container(
            width: deviceWidth,
            height: widget.maxHeight,
            child: Material(
              color: widget.backgroundColor ??
                  Theme.of(context).dialogBackgroundColor,
              elevation: 24.0,
              type: MaterialType.card,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PillGesture(
                        pillColor: widget.pillColor,
                        onVerticalDragStart: _onVerticalDragStart,
                        onVerticalDragEnd: _onVerticalDragEnd,
                        onVerticalDragUpdate: _onVerticalDragUpdate,
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                  Positioned(
                    top: 15,
                    right: 10,
                    child: Container(
                      height: 35,
                      constraints: BoxConstraints(
                        minWidth: 35,
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.times,
                            color: widget.pillColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails drag) {
    setState(() {
      _initialPosition = drag.globalPosition.dy;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails drag) {
    setState(() {
      final temp = _currentPosition;
      _currentPosition = drag.globalPosition.dy - _initialPosition;
      if (_currentPosition < 0) {
        _currentPosition = temp;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails drag) {
    if (_currentPosition > 100.0) {
      Navigator.pop(context, false);
      return;
    }
    setState(() {
      _currentPosition = 0.0;
    });
  }
}
