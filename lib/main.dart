import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:round_timer/screens/setup_screen.dart';

import 'color_schemes.g.dart';
import 'localization/localization.dart';
import 'localization/localization_delegate.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
    ]);
    KeepScreenOn.turnOn();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
      ],
      theme: ThemeData(useMaterial3: false, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: false, colorScheme: darkColorScheme),
      home: const SetupTimerScreen(),
    );
  }
}
