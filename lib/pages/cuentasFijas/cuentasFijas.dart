import 'package:flutter/material.dart';

class CuentasFijas extends StatefulWidget {
  final String heroTag;

  CuentasFijas({this.heroTag});
  @override
  _CuentasFijasState createState() => _CuentasFijasState();
}

class _CuentasFijasState extends State<CuentasFijas> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cuentas Fijas"),
        ),
        body: Container(),
      ),
    );
  }
}
