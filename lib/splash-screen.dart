import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourapp_canada/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () => navigate());
  }

  void navigate() {
    // Navigator.of(context).pushAndRemoveUntil(
    //     MySlide(builder: (context) => AuthPage()),
    //     (Route<dynamic> route) => false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    return;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.light, // status bar color
    ));
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: redCanada),
          ),
          Center(
              child: Container(
                  width: 165,
                  child: Hero(
                      tag: 'logo',
                      child: Image.asset('assets/logos/splash.png')))),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 50,
            child: Center(
              child: Container(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Colors.white),
                        child: CircularProgressIndicator(),
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
