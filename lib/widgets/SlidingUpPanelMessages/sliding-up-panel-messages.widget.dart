import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/widgets/btn/btn.widget.dart';

enum TypeMessages {
  MESSAGE,
  MESSAGEOKCANCEL,
  ERROR,
  ERROROKCANCEL,
  SUCCESS,
}

class SlidingUpPanelMessages extends StatelessWidget {
  final String message;
  final String messageTitle;
  final TypeMessages type;
  String okLabel = 'OK';
  String cancelLabel = 'Cancelar';

  SlidingUpPanelMessages(
      {@required this.message,
      @required this.messageTitle,
      @required this.type,
      this.okLabel,
      this.cancelLabel});

  getIcon() {
    switch (type) {
      case TypeMessages.MESSAGE:
        return FaIcon(
          FontAwesomeIcons.infoCircle,
          color: Colors.black,
          size: 40,
        );
        break;
      case TypeMessages.MESSAGEOKCANCEL:
        return FaIcon(
          FontAwesomeIcons.infoCircle,
          color: Colors.black,
          size: 40,
        );
        break;
      case TypeMessages.ERROR:
        return FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
          size: 40,
        );
        break;
      case TypeMessages.ERROROKCANCEL:
        return FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
          size: 40,
        );
        break;
      case TypeMessages.SUCCESS:
        return FaIcon(
          FontAwesomeIcons.checkCircle,
          color: Colors.greenAccent,
          size: 40,
        );
        break;
      default:
        return FaIcon(
          FontAwesomeIcons.infoCircle,
          color: Colors.redAccent,
          size: 40,
        );
    }
  }

  getOkLabel() {
    return okLabel != null && okLabel != '' ? okLabel : "OK";
  }

  getCancelLabel() {
    return cancelLabel != null && cancelLabel != '' ? cancelLabel : "Cancelar";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 30, left: 25, right: 25),
      child: Column(
        children: <Widget>[
          getIcon(),
          SizedBox(
            height: 15,
          ),
          Text(
            messageTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 19,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          type == TypeMessages.ERROROKCANCEL ||
                  type == TypeMessages.MESSAGEOKCANCEL
              ? Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: LoadingButtom(
                          btnLabel: getOkLabel(),
                          invert: true,
                          busy: false,
                          btnOnPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: LoadingButtom(
                          btnLabel: getCancelLabel(),
                          invert: false,
                          busy: false,
                          btnOnPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : LoadingButtom(
                  btnLabel: "Ok",
                  invert: false,
                  busy: false,
                  btnOnPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
        ],
      ),
    );
  }
}
