import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/models/Purchase.dart';

class PurchaseDetailsPage extends StatefulWidget {
  final Purchase purchase;
  PurchaseDetailsPage({this.purchase});
  @override
  _PurchaseDetailsPageState createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends State<PurchaseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.purchase.id,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: lightBtnBackground,
          title: Text(widget.purchase.description,
              style: TextStyle(color: redCanada)),
          iconTheme: IconThemeData(color: redCanada),
          centerTitle: true,
        ),
        body: Text("TEST"),
      ),
    );
  }

  void changeStatusBar() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: redCanada, //top bar color
      statusBarIconBrightness: Brightness.light, //top bar icons
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    ));
  }

  Widget title(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(color: redCanada),
      ),
    );
  }

  Widget leadingBtn(Function onTap) {
    Color color = Colors.white;
    Color _splashColor = darken(color, 0.2).withAlpha(100);
    Color _highlightColor = darken(color, 0.2).withAlpha(120);
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        splashColor: _splashColor,
        focusColor: Colors.transparent,
        highlightColor: _highlightColor,
        child: Container(
          width: 50,
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: redCanada,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  backgroundDashboard() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/photos/BackgroundImage.png'),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                redCanada,
                Color(0xFF6B160F).withAlpha(206),
              ],
              stops: [
                0.0,
                1.0,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
