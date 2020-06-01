import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:round_timer/localization/localization.dart';
import 'package:round_timer/model/timer_data.dart';

import '../constants.dart';

class TimerScreen extends StatefulWidget {
  final TimerData data;

  TimerScreen({this.data});

  @override
  TimerScreenState createState() => new TimerScreenState(data: data);
}

class TimerScreenState extends State<TimerScreen> {
  static AudioCache player = new AudioCache();
  var startBell = "sounds/start.ogg";
  var endBell = "sounds/end.ogg";
  var whistle = "sounds/whistle.ogg";
  var subscriber;

  var iconPause = Icons.pause;

  int stepInSeconds = 1;
  String status = '';
  String title = '';
  TimerData data;
  String currentNumber = "0";
  var round = 0;
  var iconStatus = setupIcon;
  var duplicate = 1654;

  TimerScreenState({this.data});

  @override
  void initState() {
    super.initState();
    startDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    status = AppLocalizations.of(context).prepareLabel;
    title = AppLocalizations.of(context).timerTitle;
  }


  Future<bool> _onWillPop() {
    subscriber.cancel();
    return new Future.value(true);
  }

  void startDelay() {
    iconStatus = setupIcon;
    round = 0;

    CountDown countDownTimer =
        CountDown(Duration(seconds: data.delay), everyTick: 1);
    subscriber = countDownTimer.stream.listen(null);

    subscriber.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    subscriber.onDone(() {
      subscriber.cancel();
      startRound();
    });
  }

  onPressPause() {
    if (subscriber.isPaused) {
      subscriber.resume();
    } else {
      subscriber.pause();
    }
  }

  void startRest() {
    iconStatus = restIcon;
    status = AppLocalizations.of(context).restLabel;
    CountDown countDownTimer =
        CountDown(Duration(seconds: data.rest), everyTick: 1);
    subscriber = countDownTimer.stream.listen(null);

    subscriber.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
      checkRest(duration.inSeconds);
    });

    subscriber.onDone(() {
      subscriber.cancel();
      startRound();
    });
  }

  startRound() {
    iconStatus = boxIcon;
    round += 1;
    status = AppLocalizations.of(context).fightLabel;
    CountDown countDownTimer =
        CountDown(Duration(seconds: data.duration), everyTick: 1);
    subscriber = countDownTimer.stream.listen(null);

    subscriber.onData((Duration duration) {
      checkRound(duration.inSeconds);
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    subscriber.onDone(() {
      subscriber.cancel();
      if (round > 0 && round < data.rounds) {
        startRest();
      } else {
        status = AppLocalizations.of(context).endLabel;
        iconStatus = endIcon;
      }
      this.onTimerTick(currentNumber, status);
    });
  }

  checkRest(int time) {
    if (duplicate != time) {
      duplicate = time;
      if (time == data.restWarning) {
        playWhistle();
      }
    }
  }

  checkRound(int time) {
    if (duplicate != time) {
      duplicate = time;
      if (time == data.roundWarning) {
        playWhistle();
      } else if (time == 0) {
        if (round > 0 && round < data.rounds) {
          playStartBell();
        } else {
          playEndBell();
        }
      } else if (time == data.duration - 1) {
        playStartBell();
      }
    }
  }

  playStartBell() {
    return Future.delayed(Duration(milliseconds: 5), () {
      player.play(startBell);
    });
  }

  playWhistle() {
    return Future.delayed(Duration(milliseconds: 5), () {
      player.play(whistle);
    });
  }

  playEndBell() {
    return Future.delayed(Duration(milliseconds: 5), () {
      player.play(endBell);
    });
  }

  void onTimerTick(String currentNumber, String status) {
    setState(() {
      currentNumber = currentNumber;
      status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalRounds = data.rounds;
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(backGroundColor),
          ),
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          '${AppLocalizations.of(context).roundLabel} $round / $totalRounds',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          '${AppLocalizations.of(context).timeLabel} : $currentNumber',
                          style: TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          status,
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Image.asset(
                          iconStatus,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 40),
                              child: FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  setState(() {
                                    iconPause = iconPause == Icons.play_arrow
                                        ? Icons.pause
                                        : Icons.play_arrow;

                                    onPressPause();
                                  });
                                },
                                child: Icon(iconPause),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                  subscriber.cancel();
                                },
                                child: Icon(Icons.refresh),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
