import 'package:flutter/material.dart';

class DashboardPageRoute extends MaterialPageRoute {
  final String itemID;
  DashboardPageRoute({WidgetBuilder builder, this.itemID})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
