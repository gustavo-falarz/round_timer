import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class DoubleField extends StatelessWidget {
  final Function onPressInc;
  final Function onPressDec;
  final Function onTextChangedMin;
  final Function onTextChangedSec;
  final TextEditingController minController;
  final TextEditingController secController;
  final String label;

  const DoubleField(
      {super.key, required this.label,
      required this.onPressInc,
      required this.onPressDec,
      required this.onTextChangedMin,
      required this.onTextChangedSec,
      required this.minController,
      required this.secController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: marginTopTimers),
          child: Center(
            child: Text(label),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(Icons.indeterminate_check_box),
                  onPressed: onPressDec(),
                ),
              ),
            ),
            Flexible(
              child: TextField(
                textAlign: TextAlign.center,
                controller: minController,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  onTextChangedMin(text);
                },
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(":"),
              ),
            ),
            Flexible(
              child: TextField(
                textAlign: TextAlign.center,
                controller: secController,
                decoration: const InputDecoration(counter: SizedBox.shrink()),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  onTextChangedSec(text);
                },
              ),
            ),
            Flexible(
              child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                      icon: const Icon(Icons.add_box), onPressed: onPressInc())),
            ),
          ],
        ),
      ],
    );
  }
}