import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'package:ourapp_canada/colors.dart';
import 'package:ourapp_canada/Dashboard/ui/pages/dashboard-home.dart';
import 'package:ourapp_canada/splash-screen.dart';
import 'package:ourapp_canada/Authors/blocs/authors.bloc.dart';

Future main() async {
  await DotEnv().load('.env');
  // initializeDateFormatting().then(
  //   (dynamic _) => runApp(MyApp()),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      bloc: AuthorsBloc(),
      child: MaterialApp(
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('pt', 'BR'), // Thai
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
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
      ),
    );
  }
}

void changeStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
  ));
}
