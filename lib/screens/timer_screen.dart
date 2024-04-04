import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:round_timer/localization/localization.dart';

import '../constants.dart';
import '../model/interval_model.dart';

class TimerScreen extends StatefulWidget {
  final List<IntervalModel> intervals;

  const TimerScreen({super.key, required this.intervals});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  final startBellPlayer = AudioPlayer();
  var endBell = "sounds/end.ogg";
  var startBell = "sounds/start.ogg";
  var whistle = "sounds/whistle.ogg";
  late CountdownTimerController controller;

  var index = 0;

  @override
  void initState() {
    super.initState();
    controller =
        CountdownTimerController(endTime: widget.intervals[index].duration);
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

  String _getIntervalName() {
    if (widget.intervals[index].type == IntervalType.rest) {
      return 'Rest';
    } else {
      return 'Round';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(backGroundColor),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        '${AppLocalizations.of(context).roundLabel} $index / ${widget.intervals.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: CountdownTimer(
                          controller: controller,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        _getIntervalName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Image.asset(
                        'iconStatus',
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
                                heroTag: null, onPressed: () {}),
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
    );
  }
}
