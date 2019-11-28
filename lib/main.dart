import 'dart:async';

import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());
const backGroundColor = 0xff263238;
const textColor = Colors.white;
const setupIcon = "assets/images/setup.png";
const boxIcon = "assets/images/box.png";
const restIcon = "assets/images/rest.png";
const endIcon = "assets/images/end.png";
const marginTopTimers = 40.0;
IconData icon = Icons.pause;

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
      title: 'Boxe training',
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
      home: SetupTimerPage(),
    );
  }
}

class CountdownTimerPageState extends State<CountdownTimerPage> {
  static AudioCache player = new AudioCache();
  var startBell = "sounds/start.ogg";
  var endBell = "sounds/end.ogg";
  var whistle = "sounds/whistle.ogg";
  var subscriber;

  int stepInSeconds = 1;
  String status = "Prepare-se!";
  Data data;
  String currentNumber = "0";
  var round = 0;
  var iconStatus = setupIcon;
  var duplicate = 1654;

  CountdownTimerPageState({this.data}) {
    startDelay();
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
    status = "Descanse";
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
    status = "Lute!";
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
        status = "Fim!";
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
          title: Text('Round Timer'),
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
                          "Round: $round / $totalRounds",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          "Tempo: $currentNumber",
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
                                    icon = icon == Icons.play_arrow
                                        ? Icons.pause
                                        : Icons.play_arrow;

                                    onPressPause();
                                  });
                                },
                                child: Icon(icon),
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

class SetupTimerPageState extends State<SetupTimerPage> {
  final minController = TextEditingController();
  final secController = TextEditingController();
  final restMinController = TextEditingController();
  final restSecController = TextEditingController();
  final delayController = TextEditingController();
  final roundController = TextEditingController();
  final roundWarningController = TextEditingController();
  final restWarningController = TextEditingController();

  int rounds = 6;

  String min = "3";
  String sec = "00";
  String restMin = "1";
  String restSec = "00";
  int delay = 10;
  int restWarning = 10;
  int roundWarning = 30;

//  String min = "0";
//  String sec = "10";
//  String restMin = "0";
//  String restSec = "10";
//  int delay = 10;
//  int restWarning = 5;
//  int roundWarning = 5;

  var data = Data();

  int calcRound() {
    return int.parse(min) * 60 + int.parse(sec);
  }

  int calcRest() {
    return int.parse(restMin) * 60 + int.parse(restSec);
  }

  incDuration() {
    min = (int.parse(min) + 1).toString();
    minController.text = min.toString();
  }

  decDuration() {
    if (int.parse(min) > 0) min = (int.parse(min) - 1).toString();
    minController.text = min.toString();
  }

  incRest() {
    restMin = (int.parse(restMin) + 1).toString();
    restMinController.text = restMin.toString();
  }

  decRest() {
    if (int.parse(restMin) > 0) restMin = (int.parse(restMin) - 1).toString();
    restMinController.text = restMin.toString();
  }

  incDelay() {
    delay = delay + 1;
    delayController.text = delay.toString();
  }

  decDelay() {
    if (delay > 0) {
      delay = delay - 1;
      delayController.text = delay.toString();
    }
  }

  incRounds() {
    rounds = rounds + 1;
    roundController.text = rounds.toString();
  }

  decRounds() {
    if (rounds > 0) rounds = rounds - 1;
    roundController.text = rounds.toString();
  }

  incRoundWarning() {
    roundWarning = roundWarning + 1;
    roundWarningController.text = roundWarning.toString();
  }

  decRoundWarning() {
    if (roundWarning > 0) roundWarning = roundWarning - 1;
    roundWarningController.text = roundWarning.toString();
  }

  incRestWarning() {
    restWarning = restWarning + 1;
    restWarningController.text = restWarning.toString();
  }

  decRestWarning() {
    if (restWarning > 0) restWarning = restWarning - 1;
    restWarningController.text = restWarning.toString();
  }

  @override
  Widget build(BuildContext context) {
    minController.text = min.toString();
    secController.text = sec.toString();
    restMinController.text = restMin.toString();
    restSecController.text = restSec.toString();
    delayController.text = delay.toString();
    roundController.text = rounds.toString();
    roundWarningController.text = roundWarning.toString();
    restWarningController.text = restWarning.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Round Timer'),
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
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Quantidade de rounds"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decRounds();
                                })),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: roundController,
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                            ),
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              rounds = int.parse(text);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incRounds();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Duração do round (mm:ss)"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decDuration();
                                })),
                      ),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: minController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            min = text;
                          },
                        ),
                      ),
                      Flexible(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(":"),
                      )),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: secController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            sec = text;
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incDuration();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Descanso (mm:ss)"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decRest();
                                })),
                      ),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: restMinController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            restMin = text;
                          },
                        ),
                      ),
                      Flexible(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Text(":"),
                      )),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: restSecController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            restSec = text;
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incRest();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Preparação (ss)"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decDelay();
                                })),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: delayController,
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                            ),
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              restWarning = int.parse(text);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incDelay();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Aviso final de round (ss)"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decRoundWarning();
                                })),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: roundWarningController,
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                            ),
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              roundWarning = int.parse(text);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incRoundWarning();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marginTopTimers),
                    child: Center(
                      child: Text("Aviso final de descanso (ss)"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: IconButton(
                                icon: Icon(Icons.indeterminate_check_box),
                                onPressed: () {
                                  decRestWarning();
                                })),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: restWarningController,
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                            ),
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (text) {
                              restWarning = int.parse(text);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: IconButton(
                                icon: Icon(Icons.add_box),
                                onPressed: () {
                                  incRestWarning();
                                })),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        startCountDown(context);
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text("Começar"),
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
    data = Data(
        duration: calcRound(),
        rest: calcRest(),
        rounds: rounds,
        delay: delay,
        restWarning: restWarning,
        roundWarning: roundWarning);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountdownTimerPage(
                data: data,
              )),
    );
  }
}

class CountdownTimerPage extends StatefulWidget {
  final Data data;

  CountdownTimerPage({this.data});

  @override
  CountdownTimerPageState createState() =>
      new CountdownTimerPageState(data: data);
}

class SetupTimerPage extends StatefulWidget {
  @override
  SetupTimerPageState createState() => new SetupTimerPageState();
}

class Data {
  int rounds;
  int duration;
  int rest;
  int delay;
  int roundWarning;
  int restWarning;

  Data(
      {this.rounds,
      this.duration,
      this.rest,
      this.delay,
      this.roundWarning,
      this.restWarning});
}
