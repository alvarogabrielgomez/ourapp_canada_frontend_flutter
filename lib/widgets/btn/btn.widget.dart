import 'package:flutter/material.dart';

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
