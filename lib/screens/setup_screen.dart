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
  final minController = TextEditingController();
  final secController = TextEditingController();
  final restMinController = TextEditingController();
  final restSecController = TextEditingController();
  final delayController = TextEditingController();
  final roundController = TextEditingController();
  final roundWarningController = TextEditingController();
  final restWarningController = TextEditingController();

  int rounds = 6;

  String roundMin = "3";
  String roundSec = "00";
  String restMin = "1";
  String restSec = "00";
  int delay = 10;
  int restWarning = 10;
  int roundWarning = 10;

  String title= '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    title = AppLocalizations.of(context)!.appName!;
  }

  int calcRound() {
    return int.parse(roundMin) * 60 + int.parse(roundSec);
  }

  int calcRest() {
    return int.parse(restMin) * 60 + int.parse(restSec);
  }

  incDuration() {
    // roundMin = (int.parse(roundMin) + 1).toString();
    // minController.text = roundMin.toString();
  }

  decDuration() {
    // if (int.parse(roundMin) > 0) {
    //   roundMin = (int.parse(roundMin) - 1).toString();
    // }
    // minController.text = roundMin.toString();
  }

  incRest() {
    // restMin = (int.parse(restMin) + 1).toString();
    // restMinController.text = restMin.toString();
  }

  decRest() {
    // if (int.parse(restMin) > 0) restMin = (int.parse(restMin) - 1).toString();
    // restMinController.text = restMin.toString();
  }

  incDelay() {
    // delay = delay + 1;
    // delayController.text = delay.toString();
  }

  decDelay() {
    // if (delay > 0) {
    //   delay = delay - 1;
    //   delayController.text = delay.toString();
    // }
  }

  incRounds() {
    // rounds = rounds + 1;
    // roundController.text = rounds.toString();
  }

  decRounds() {
    // if (rounds > 0) rounds = rounds - 1;
    // roundController.text = rounds.toString();
  }

  incRoundWarning() {
    // roundWarning = roundWarning + 1;
    // roundWarningController.text = roundWarning.toString();
  }

  decRoundWarning() {
    // if (roundWarning > 0) roundWarning = roundWarning - 1;
    // roundWarningController.text = roundWarning.toString();
  }

  incRestWarning() {
    // restWarning = restWarning + 1;
    // restWarningController.text = restWarning.toString();
  }

  decRestWarning() {
    // if (restWarning > 0) restWarning = restWarning - 1;
    // restWarningController.text = restWarning.toString();
  }

  @override
  Widget build(BuildContext context) {
    minController.text = roundMin.toString();
    secController.text = roundSec.toString();
    restMinController.text = restMin.toString();
    restSecController.text = restSec.toString();
    delayController.text = delay.toString();
    roundController.text = rounds.toString();
    roundWarningController.text = roundWarning.toString();
    restWarningController.text = restWarning.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(backGroundColor),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleField(
                    label: AppLocalizations.of(context)!.roundAmountLabel!,
                    onPressDec: () {
                      decRounds();
                    },
                    onPressInc: () {
                      incRounds();
                    },
                    onTextChanged: (text) {
                      rounds = int.parse(text);
                    },
                    controller: roundController,
                  ),
                  DoubleField(
                    label: AppLocalizations.of(context)!.roundDurationLabel!,
                    onPressInc: () {
                      incDuration();
                    },
                    onPressDec: () {
                      decDuration();
                    },
                    onTextChangedMin: (text) {
                      roundMin = text;
                    },
                    onTextChangedSec: (text) {
                      roundSec = text;
                    },
                    minController: minController,
                    secController: secController,
                  ),
                  DoubleField(
                    label: AppLocalizations.of(context)!.restDurationLabel!,
                    onPressInc: () {
                      incRest();
                    },
                    onPressDec: () {
                      decRest();
                    },
                    onTextChangedMin: (text) {
                      restMin = text;
                    },
                    onTextChangedSec: (text) {
                      restSec = text;
                    },
                    minController: restMinController,
                    secController: restSecController,
                  ),
                  SingleField(
                    label: AppLocalizations.of(context)!.delayDurationLabel!,
                    onPressDec: () {
                      decDelay();
                    },
                    onPressInc: () {
                      incDelay();
                    },
                    onTextChanged: (text) {
                      delay = int.parse(text);
                    },
                    controller: delayController,
                  ),
                  SingleField(
                    label: AppLocalizations.of(context)!.roundWarningLabel!,
                    onPressDec: () {
                      decRoundWarning();
                    },
                    onPressInc: () {
                      incRoundWarning();
                    },
                    onTextChanged: (text) {
                      roundWarning = int.parse(text);
                    },
                    controller: roundWarningController,
                  ),
                  SingleField(
                    label: AppLocalizations.of(context)!.restWarningLabel!,
                    onPressDec: () {
                      decRestWarning();
                    },
                    onPressInc: () {
                      decRestWarning();
                    },
                    onTextChanged: (text) {
                      restWarning = int.parse(text);
                    },
                    controller: restWarningController,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        startCountDown(context);
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text(AppLocalizations.of(context)!.startLabel!),
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
              )),
    );
  }
}
