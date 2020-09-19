import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/pages/home/dashboard-home.dart';
import 'package:ourapp_canada/pages/splash/splash-screen.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'OurApp Canada',
      theme: ThemeData(
        primarySwatch: createMaterialColor(redCanada),
        fontFamily: "Lato",
      ),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (context) => SplashScreen(),
        '/': (context) => Dashboard(),
        // '/': (context) => AuthPage(),
        // '/dashboard': (context) => HomePage(),
      },
    );
  }
}

void changeStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
  ));
}
