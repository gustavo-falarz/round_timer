import 'package:flutter/material.dart';
import 'package:round_timer/components/double_field.dart';
import 'package:round_timer/localization/localization.dart';
import 'package:round_timer/model/interval_model.dart';
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
  int roundSec = 0;
  int restMin = 1;
  int restSec = 0;
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
    return restMin * 60 + restSec;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(backGroundColor),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleField(
                    initialValue: rounds,
                    label: AppLocalizations.of(context).roundAmountLabel,
                    onTextChanged: (value) {
                      rounds = value;
                    },
                  ),
                  DoubleField(
                    initialValueMin: roundMin,
                    initialValueSec: roundSec,
                    label: AppLocalizations.of(context).roundDurationLabel,
                    onTextChangedMin: (value) {
                      roundMin = value;
                    },
                    onTextChangedSec: (value) {
                      roundSec = value;
                    },
                  ),
                  DoubleField(
                    initialValueMin: restMin,
                    initialValueSec: restSec,
                    label: AppLocalizations.of(context).restDurationLabel,
                    onTextChangedMin: (value) {
                      restMin = value;
                    },
                    onTextChangedSec: (value) {
                      restSec = value;
                    },
                  ),
                  SingleField(
                    initialValue: delay,
                    label: AppLocalizations.of(context).delayDurationLabel,
                    onTextChanged: (value) {
                      delay = value;
                    },
                  ),
                  SingleField(
                    initialValue: roundWarning,
                    label: AppLocalizations.of(context).roundWarningLabel,
                    onTextChanged: (value) {
                      roundWarning = value;
                    },
                  ),
                  SingleField(
                    initialValue: restWarning,
                    label: AppLocalizations.of(context).restWarningLabel,
                    onTextChanged: (value) {
                      restWarning = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: FilledButton.icon(
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
        rounDuration: calcRound(),
        rest: calcRest(),
        rounds: rounds,
        delay: delay,
        restWarning: restWarning,
        roundWarning: roundWarning);

    List<IntervalModel> intervals = [];
    if (delay > 0) {
      intervals.add(IntervalModel(
        duration: delay,
        type: IntervalType.delay,
        warning: data.roundWarning,
      ));
    }
    for (var i = 0; i < rounds; i++) {
      intervals.add(IntervalModel(
        duration: data.rounDuration,
        type: IntervalType.round,
        warning: data.roundWarning,
      ));
      if (i != rounds) {
        intervals.add(IntervalModel(
          duration: data.rest,
          type: IntervalType.rest,
          warning: data.restWarning,
        ));
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerScreen(
          intervals: intervals,
        ),
      ),
    );
  }
}
