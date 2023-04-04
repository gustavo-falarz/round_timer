import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:round_timer/components/icons.dart';

import '../constants.dart';

class DoubleField extends StatelessWidget {
  final Function onTextChangedMin;
  final Function onTextChangedSec;
  final String label;
  final int initialValueMin;
  final int initialValueSec;

  DoubleField({
    super.key,
    required this.label,
    required this.onTextChangedMin(int value),
    required this.onTextChangedSec(int value),
    required this.initialValueMin,
    required this.initialValueSec,
  });

  final _controllerMin = TextEditingController();
  final _controllerSec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controllerMin.text = initialValueMin.toString();
    _controllerSec.text = initialValueSec.toString();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: marginTopTimers),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const DecIcon(),
                  onPressed: () {
                    onPressInc();
                  },
                ),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _controllerMin,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    onTextChangedMin(text);
                  }
                },
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  ":",
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _controllerSec,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    onTextChangedSec(text);
                  }
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const IncIcon(),
                  onPressed: () {
                    onPressInc();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  onPressDec() {
    var value = int.parse(_controllerMin.text);
    value = value - 1;
    _controllerMin.text = value.toString();
  }

  onPressInc() {
    var value = int.parse(_controllerMin.text);
    value = value + 1;
    _controllerMin.text = value.toString();
  }
}
