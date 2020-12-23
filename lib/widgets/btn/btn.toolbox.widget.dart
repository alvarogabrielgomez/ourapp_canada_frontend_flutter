import 'package:flutter/material.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/widgets/btn/btn.widget.dart';

class BtnToolbox extends StatelessWidget {
  final Function onTap;
  final Widget icon;
  final Color color;
  final Widget label;

  BtnToolbox(
      {@required this.onTap,
      @required this.icon,
      this.color,
      @required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 27),
      child: BtnBasic(
        activeState: false,
        color: color != null ? color : redCanadaDark.withAlpha(200),
        width: 105,
        height: 105,
        borderRadius: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: icon,
              ),
              SizedBox(height: 10),
              Center(
                child: label,
              )
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
