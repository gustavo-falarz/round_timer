import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: SetupTimerPage(),
    );
  }
}

class CountdownTimerPageState extends State<CountdownTimerPage> {
  static AudioCache player = new AudioCache();
  var startBell = "start.mp3";
  var endBell = "end.mp3";
  int stepInSeconds = 1;
  String status = "Prepare-se!";
  Data data;
  String currentNumber = "0";

  CountdownTimerPageState({this.data}) {
    startDelay();
  }

  void startDelay() {
    CountDown countDownTimer = CountDown(Duration(seconds: data.delay));
    var sub = countDownTimer.stream.listen(null);

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
    var sub = countDownTimer.stream.listen(null);

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
    status = "Lute";
    CountDown countDownTimer = CountDown(Duration(seconds: data.duration));
    var sub = countDownTimer.stream.listen(null);

    sub.onData((Duration duration) {
      currentNumber = duration.toString().substring(2, 7);
      this.onTimerTick(currentNumber, status);
    });

    sub.onDone(() {
      if (data.rounds > 1) {
        data.rounds = data.rounds - 1;
        startRest();
      } else {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Round Timer'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Tempo: $currentNumber",
                style: TextStyle(color: Colors.yellow, fontSize: 25.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Round: " + (data.rounds - data.rounds + 1).toString(),
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25.0,
                ),
              ),
            ),
          ],
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
  int rounds = 2;
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: Text("Quantidade de rounds"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: TextField(
              textAlign: TextAlign.center,
              controller: roundController,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                rounds = int.parse(text);
              },
            ),
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
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: minController,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    min = text;
                  },
                ),
              ),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Text(":"),
              )),
              Flexible(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: secController,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    sec = text;
                  },
                ),
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
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: restMinController,
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    restSec = text;
                  },
                ),
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
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: delayMinController,
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    delaySec = text;
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              child: Text("Start"),
              onPressed: () {
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
              },
            ),
          ),
        ],
      ),
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
