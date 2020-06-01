import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:round_timer/screens/setup_screen.dart';
import 'package:screen/screen.dart';

import 'constants.dart';
import 'localization/localization.dart';
import 'localization/localization_delegate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
    ]);
    Screen.keepOn(true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appName,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pt', ''),
      ],
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textColor),
          ),
        ),
        backgroundColor: Color(backGroundColor),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
          title: TextStyle(color: textColor),
          body1: TextStyle(color: textColor),
          overline: TextStyle(color: textColor),
        ),
      ),
      home: SetupTimerScreen(),
    );
  }
}