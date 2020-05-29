import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:round_timer/screens/setup_screen.dart';
import 'package:screen/screen.dart';

import 'constants.dart';

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
      title: 'Round timer',
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