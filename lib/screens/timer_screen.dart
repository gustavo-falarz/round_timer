import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../model/interval_model.dart';

class TimerScreen extends StatefulWidget {
  final List<IntervalModel> intervals;

  const TimerScreen({super.key, required this.intervals});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  final audioPlayer = AudioPlayer();
  var endBell = "sounds/end.ogg";
  var startBell = "sounds/start.ogg";
  var whistle = "sounds/whistle.ogg";
  CountDownController controller = CountDownController();
  int duration = 0;
  var index = -1;

  playStartBell() {
    audioPlayer.play(AssetSource(startBell));
  }

  playWhistle() {
    audioPlayer.play(AssetSource(whistle));
  }

  playEndBell() {
    audioPlayer.play(AssetSource(endBell));
  }

  String _getIntervalName() {
    if (index == -1) {
      return 'Prepare';
    }
    switch (widget.intervals[index].type) {
      case IntervalType.rest:
        return 'Rest';
      case IntervalType.round:
        return 'Round';
      case IntervalType.delay:
        return 'Prepare';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round timer'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularCountDownTimer(
            duration: duration,
            initialDuration: duration,
            controller: controller,
            width: MediaQuery.of(context).size.width / 1.7,
            height: MediaQuery.of(context).size.height / 1.7,
            ringColor: Theme.of(context).colorScheme.secondary,
            ringGradient: null,
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            fillGradient: null,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundGradient: null,
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
                fontSize: 38.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: false,
            onComplete: () {
              index++;
              duration = widget.intervals[index].duration;
              controller.restart(duration: duration);
            },
            onChange: (String timeStamp) {
              debugPrint('Countdown Changed $timeStamp');
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              _playSound(duration);
              return Function.apply(_defaultFormatterFunction, [duration]);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (controller.isPaused) {
                    controller.resume();
                  } else {
                    controller.start();
                  }
                },
                child: const Icon(Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!controller.isPaused) {
                    controller.pause();
                  }
                },
                child: const Icon(Icons.pause),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.reset();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _playSound(Duration currentDuration) {
    if (index == -1) {
      return;
    }

    IntervalModel interval = widget.intervals[index];
    if (interval.type != IntervalType.delay) {
      if (currentDuration.inSeconds == interval.duration) {
        playStartBell();
      }
      if (currentDuration.inSeconds == 0) {
        playStartBell();
      }
      if (interval.warning != 0 &&
          interval.warning == currentDuration.inSeconds) {
        playWhistle();
      }
    }
  }

  String _defaultFormatterFunction(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    final twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return '$twoDigitMinutes:$twoDigitSeconds\n${_getIntervalName()}';
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
