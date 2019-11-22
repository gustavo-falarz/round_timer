import 'dart:async';

import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

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
        accentColor: Colors.red),
      home: SetupTimerPage(),
    );
  }
}

class CountdownTimerPageState extends State<CountdownTimerPage> {
  static AudioCache player = new AudioCache();
  var startBell = "start.mp3";
  var endBell = "end.mp3";
  var sub;
  int stepInSeconds = 1;
  String status = "Prepare-se!";
  Data data;
  String currentNumber = "0";
  var round = 0;

  CountdownTimerPageState({this.data}) {
    startDelay();
  }

  Future<bool> _onWillPop() {
    sub.cancel();
    return new Future.value(true);
  }

  void startDelay() {
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

  void startRest() {
    status = "Descanse";
    CountDown countDownTimer = CountDown(Duration(seconds: data.rest));
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

  startRound() {
    player.play(startBell);
    round += 1;
    status = "Lute!";
    CountDown countDownTimer = CountDown(Duration(seconds: data.duration));
    sub = countDownTimer.stream.listen(null);

    sub.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    sub.onDone(() {
      if (round > 1 && round < data.rounds) {
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/setup_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "Round: " + (round).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "Tempo: $currentNumber",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
  String min = "3";
  String sec = "00";
  String restMin = "1";
  String restSec = "00";
  String delayMin = "0";
  String delaySec = "30";
  int rounds = 6;
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

  @override
  Widget build(BuildContext context) {
    minController.text = min.toString();
    secController.text = sec.toString();
    restMinController.text = restMin.toString();
    restSecController.text = restSec.toString();
    delayMinController.text = delayMin.toString();
    delaySecController.text = delaySec.toString();
    roundController.text = rounds.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Round Timer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(55, 71, 79, 1),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40),
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
                      decoration: InputDecoration(counter: SizedBox.shrink()),
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
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text("Duração do round"),
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
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text("Descanço"),
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
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Text(":"),
                )),
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: restSecController,
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text("Preparação"),
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
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Text(":"),
                )),
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: delaySecController,
                    decoration: InputDecoration(counter: SizedBox.shrink()),
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
      ),
    );
  }

  void startCountDown(BuildContext context) {
    data = Data(
        duration: calcRound(),
        rest: calcRest(),
        rounds: rounds,
        delay: calcDelay());
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

  Data({this.rounds, this.duration, this.rest, this.delay});
}
