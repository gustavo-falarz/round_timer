import 'package:flutter/material.dart';
import 'package:round_timer/components/double_field.dart';
import 'package:round_timer/localization/localization.dart';
import 'package:round_timer/model/timer_data.dart';
import 'package:round_timer/screens/timer_screen.dart';

import '../components/single_field.dart';
import '../constants.dart';

class SetupTimerScreen extends StatefulWidget {
  const SetupTimerScreen({super.key});

  @override
  SetupTimerState createState() => SetupTimerState();
}

class Data {
  int rounds;
  int duration;
  int rest;
  int delay;
  int roundWarning;
  int restWarning;

  Data(
      {required this.rounds,
      required this.duration,
      required this.rest,
      required this.delay,
      required this.roundWarning,
      required this.restWarning});
}

class SetupTimerState extends State<SetupTimerScreen> {
  int rounds = 6;

  int roundMin = 3;
  int roundSec = 00;
  int restMin = 1;
  int restSec = 00;
  int delay = 10;
  int restWarning = 10;
  int roundWarning = 10;

  String title = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    title = AppLocalizations.of(context).appName;
  }

  int calcRound() {
    return roundMin * 60 + roundSec;
  }

  int calcRest() {
    return restMin* 60 + restSec;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(backGroundColor),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleField(
                    label: AppLocalizations.of(context).roundAmountLabel,
                    onTextChanged: (text) {
                      rounds = int.parse(text);
                    },
                  ),
                  DoubleField(
                    label: AppLocalizations.of(context).roundDurationLabel,
                    onTextChangedMin: (text) {
                      roundMin = int.parse(text);
                    },
                    onTextChangedSec: (text) {
                      roundSec = int.parse(text);
                    },
                  ),
                  DoubleField(
                    label: AppLocalizations.of(context).restDurationLabel,
                    onTextChangedMin: (text) {
                      restMin = int.parse(text);
                    },
                    onTextChangedSec: (text) {
                      restSec = int.parse(text);
                    },
                  ),
                  SingleField(
                    label: AppLocalizations.of(context).delayDurationLabel,
                    onTextChanged: (text) {
                      delay = int.parse(text);
                    },
                  ),
                  SingleField(
                    label: AppLocalizations.of(context).roundWarningLabel,
                    onTextChanged: (text) {
                      roundWarning = int.parse(text);
                    },
                  ),
                  SingleField(
                    label: AppLocalizations.of(context).restWarningLabel,
                    onTextChanged: (text) {
                      restWarning = int.parse(text);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        startCountDown(context);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(AppLocalizations.of(context).startLabel),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void startCountDown(BuildContext context) {
    var data = TimerData(
        duration: calcRound(),
        rest: calcRest(),
        rounds: rounds,
        delay: delay,
        restWarning: restWarning,
        roundWarning: roundWarning);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(
          data: data,
        ),
      ),
    );
  }
}
