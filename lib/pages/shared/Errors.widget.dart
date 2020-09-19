import 'package:flutter/material.dart';

class ErrorRetrieveInfo extends StatelessWidget {
  final String error;
  ErrorRetrieveInfo({@required this.error});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: Icon(
                Icons.error_outline,
                size: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: Text(error),
            ),
          ],
        ),
      ),
    );
  }
}
