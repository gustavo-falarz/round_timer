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
  var startBell = "start.mp3";
  var endBell = "end.mp3";
  var whistle = "whistle.mp3";
  var sub;
  int stepInSeconds = 1;
  String status = "Prepare-se!";
  Data data;
  String currentNumber = "0";
  var round = 0;
  var iconStatus = setupIcon;

  CountdownTimerPageState({this.data}) {
    startDelay();
  }

  Future<bool> _onWillPop() {
    sub.cancel();
    return new Future.value(true);
  }

  void startDelay() {
    iconStatus = setupIcon;
    round = 0;
    CountDown countDownTimer = CountDown(Duration(seconds: data.delay));
    sub = countDownTimer.stream.listen(null);

    sub.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    sub.onDone(() {
      sub.cancel();
      startRound();
    });
  }

  onPressPause(IconData iconData) {
    if (sub.isPaused) {
      sub.resume();
    } else {
      sub.pause();
    }
  }

  void startRest() {
    iconStatus = restIcon;
    status = "Descanse";
    CountDown countDownTimer = CountDown(Duration(seconds: data.rest));
    sub = countDownTimer.stream.listen(null);

    sub.onData((Duration duration) {
      checkRest(duration.inSeconds);
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    sub.onDone(() {
      sub.cancel();
      startRound();
    });
  }

  startRound() {
    player.play(startBell);
    iconStatus = boxIcon;
    round += 1;
    status = "Lute!";
    CountDown countDownTimer = CountDown(Duration(seconds: data.duration));
    sub = countDownTimer.stream.listen(null);

    sub.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      checkRound(duration.inSeconds);
      this.onTimerTick(currentNumber, status);
    });

    sub.onDone(() {
      if (round > 0 && round < data.rounds) {
        player.play(startBell);
        startRest();
      } else {
        status = "Fim!";
        this.onTimerTick(currentNumber, status);
        sub.cancel();
        player.play(endBell);
      }
    });
  }

  checkRest(int time) {
    if (time == data.restWarning) {
      player.play(whistle);
    }
  }

  checkRound(int time) {
    if (time == data.roundWarning) {
      player.play(whistle);
    }
  }

  void onTimerTick(String currentNumber, String status) {
    setState(() {
      currentNumber = currentNumber;
      status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          "Round: " + (round).toString(),
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

                                    onPressPause(icon);
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
  final delayMinController = TextEditingController();
  final delaySecController = TextEditingController();
  final roundController = TextEditingController();
  final roundWarningController = TextEditingController();
  final restWarningController = TextEditingController();
  String min = "3";
  String sec = "00";
  String restMin = "1";
  String restSec = "00";
  String delayMin = "0";
  String delaySec = "10";
  int rounds = 6;
  int restWarning = 10;
  int roundWarning = 30;
  var data = Data();

  int calcRound() {
    return int.parse(min) * 60 + int.parse(sec);
  }

  int calcRest() {
    return int.parse(restMin) * 60 + int.parse(restSec);
  }

  int calcDelay() {
    return int.parse(delayMin) * 60 + int.parse(delaySec);
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
    delayMin = (int.parse(delayMin) + 1).toString();
    delayMinController.text = delayMin.toString();
  }

  decDelay() {
    if (int.parse(delayMin) > 0) {
      delayMin = (int.parse(delayMin) - 1).toString();
      delayMinController.text = delayMin.toString();
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
    delayMinController.text = delayMin.toString();
    delaySecController.text = delaySec.toString();
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
                      child: Text("Preparação (mm:ss)"),
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
                                  decDelay();
                                })),
                      ),
                      Flexible(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: delayMinController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            delayMin = text;
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
                          controller: delaySecController,
                          decoration:
                              InputDecoration(counter: SizedBox.shrink()),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          onChanged: (text) {
                            delaySec = text;
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.only(top: 20),
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
        delay: calcDelay(),
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
