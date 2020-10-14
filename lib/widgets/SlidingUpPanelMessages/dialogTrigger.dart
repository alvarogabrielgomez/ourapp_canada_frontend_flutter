import 'package:flutter/material.dart';
import 'package:ourapp_canada/widgets/customPlugins/slide_popup_dialog-0.0.2/slide_popup_dialog.dart'
    as slideDialog;

import 'sliding-up-panel-messages.widget.dart';

class DialogMessages {
  static Future<T> openDialogMessage<T>(
      {BuildContext context,
      String title,
      String message,
      TypeMessages typeMessage = TypeMessages.MESSAGE}) {
    return slideDialog.showSlideDialog(
      maxHeight: 300,
      context: context,
      child: SlidingUpPanelMessages(
        messageTitle: title,
        message: message,
        type: typeMessage,
      ),
    );
  }

  static Future<T> openDialogYesOrNo<T>(
      {BuildContext context,
      String title,
      String message,
      String okLabel,
      String noLabel,
      double maxHeight,
      TypeMessages typeMessage = TypeMessages.MESSAGEOKCANCEL}) {
    return slideDialog.showSlideDialog(
      maxHeight: maxHeight,
      context: context,
      child: SlidingUpPanelMessages(
        messageTitle: title,
        message: message,
        type: typeMessage,
        okLabel: okLabel,
        cancelLabel: noLabel,
      ),
    );
  }
}

class PanelOption {
  static Future<T> openPanel<T>({BuildContext context, Widget child}) {
    return slideDialog.showSlideDialog(
      maxHeight: MediaQuery.of(context).size.height - 50,
      context: context,
      child: child,
    );
  }
}
