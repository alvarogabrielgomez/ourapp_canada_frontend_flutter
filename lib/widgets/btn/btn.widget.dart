import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/colors.dart';

class BtnBasic extends StatelessWidget {
  final Function onTap;
  final String btnLabel;
  final Color color;
  final Widget child;
  final double width;
  final double height;
  BtnBasic(
      {this.btnLabel,
      @required this.color,
      @required this.onTap,
      this.child,
      @required this.width,
      @required this.height});
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
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: _splashColor,
        focusColor: Colors.transparent,
        highlightColor: _highlightColor,
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          child: btnLabel != "" && btnLabel != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      btnLabel,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

class LoadingButtom extends StatelessWidget {
  var busy = false;
  var invert = false;
  Function btnOnPressed;
  String btnLabel;
  Color color;

  LoadingButtom({
    @required this.busy,
    @required this.btnOnPressed,
    @required this.btnLabel,
    @required this.invert,
    this.color,
  });

  Color getColor(BuildContext context) {
    Color col = Colors.transparent;
    if (color != null) {
      col = color;
    }
    return col;
  }

  bool isInverted() {
    var res = false;
    if (invert != null) {
      res = invert;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return busy
        ? Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : FlatButton(
            color: isInverted()
                ? Theme.of(context).primaryColor
                : getColor(context),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                btnLabel,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isInverted()
                        ? Colors.white
                        : Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: btnOnPressed,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50.0),
              side: isInverted()
                  ? BorderSide.none
                  : BorderSide(color: Theme.of(context).primaryColor),
            ),
          );
  }
}

class LeadingBtn extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function onTap;
  LeadingBtn({this.color, this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    Color _splashColor = darken(color, 0.2).withAlpha(100);
    Color _highlightColor = darken(color, 0.2).withAlpha(120);
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: color,
      child: InkWell(
        customBorder: CircleBorder(),
        splashColor: _splashColor,
        focusColor: Colors.transparent,
        highlightColor: _highlightColor,
        child: Container(
          width: 50,
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
