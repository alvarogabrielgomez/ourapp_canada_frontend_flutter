import 'package:flutter/material.dart';

class ErrorRetrieveInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
