import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';
import 'package:round_timer/localization/localization.dart';
import 'package:round_timer/model/timer_data.dart';

import '../constants.dart';

class TimerScreen extends StatefulWidget {
  final TimerData data;

  const TimerScreen({super.key, required this.data});

  @override
  TimerScreenState createState() => TimerScreenState(data: data);
}

class TimerScreenState extends State<TimerScreen> {
  final startBellPlayer = AudioPlayer();
  var endBell = "sounds/end.ogg";
  var startBell = "sounds/start.ogg";
  var whistle = "sounds/whistle.ogg";

  StreamSubscription<CountdownTimer>? subscriber;

  var iconPause = Icons.pause;

  int stepInSeconds = 1;
  String status = '';
  String title = '';
  TimerData data;
  String currentNumber = "0";
  var round = 0;
  var iconStatus = setupIcon;
  var duplicate = 1654;

  TimerScreenState({required this.data});

  @override
  void initState() {
    super.initState();
    startDelay();
  }


  @override
  void dispose() {
    subscriber?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    status = AppLocalizations.of(context)!.prepareLabel!;
    title = AppLocalizations.of(context)!.timerTitle!;
  }

  Future<bool> _onWillPop() {
    subscriber?.cancel();
    return Future.value(true);
  }

  void startDelay() {
    iconStatus = setupIcon;
    round = 0;

    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: data.delay + 2),
      const Duration(seconds: 1),
    );

    subscriber = countDownTimer.listen(null);

    subscriber?.onData((duration) {
      currentNumber = duration.remaining.toString().substring(2, 7);
      onTimerTick(currentNumber, status);
    });

    subscriber?.onDone(() {
      subscriber?.cancel();
      startRound();
    });
  }

  onPressPause() {
    if (subscriber!.isPaused) {
      subscriber?.resume();
    } else {
      subscriber?.pause();
    }
  }

  void startRest() {
    iconStatus = restIcon;
    status = AppLocalizations.of(context)!.restLabel!;

    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: data.rest + 2),
      const Duration(seconds: 1),
    );

    subscriber = countDownTimer.listen(null);

    subscriber?.onData((duration) {
      currentNumber = duration.remaining.toString().substring(2, 7);
      onTimerTick(currentNumber, status);
      checkRest(duration.remaining.inSeconds);
    });

    subscriber?.onDone(() {
      subscriber?.cancel();
      startRound();
    });
  }

  startRound() {
    iconStatus = boxIcon;
    round += 1;
    status = AppLocalizations.of(context)!.fightLabel!;

    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: data.duration + 2),
      const Duration(seconds: 1),
    );

    subscriber = countDownTimer.listen(null);

    subscriber?.onData((duration) {
      checkRound(duration.remaining.inSeconds);
      currentNumber = duration.remaining.toString().substring(2, 7);
      onTimerTick(currentNumber, status);
    });

    subscriber?.onDone(() {
      subscriber?.cancel();
      if (round > 0 && round < data.rounds) {
        startRest();
      } else {
        status = AppLocalizations.of(context)!.endLabel!;
        iconStatus = endIcon;
      }
      onTimerTick(currentNumber, status);
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
      } else if (time == data.duration) {
        playStartBell();
      }
    }
  }

  playStartBell() {
    return Future.delayed(const Duration(milliseconds: 5), () {
      startBellPlayer.play(AssetSource(startBell));
    });
  }

  playWhistle() {
    return Future.delayed(const Duration(milliseconds: 5), () {
      startBellPlayer.play(AssetSource(whistle));
    });
  }

  playEndBell() {
    return Future.delayed(const Duration(milliseconds: 5), () {
      startBellPlayer.play(AssetSource(endBell));
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
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
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          '${AppLocalizations.of(context)!.roundLabel!} $round / $totalRounds',
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          '${AppLocalizations.of(context)!.timeLabel!} $currentNumber',
                          style: const TextStyle(
                              fontSize: 50.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          status,
                          style: const TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          iconStatus,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
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
                              padding: const EdgeInsets.only(left: 40),
                              child: FloatingActionButton(
                                heroTag: null,
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                  subscriber?.cancel();
                                },
                                child: const Icon(Icons.refresh),
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
