import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class SingleField extends StatelessWidget {
  final Function onPressInc;
  final Function onPressDec;
  final Function onTextChanged;
  final TextEditingController controller;
  final String label;

  const SingleField(
      {super.key,
      required this.onPressInc,
      required this.onPressDec,
      required this.onTextChanged,
      required this.controller,
      required this.label});

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
                padding: const EdgeInsets.only(right: 35),
                child: IconButton(
                  icon: const Icon(Icons.indeterminate_check_box),
                  onPressed: onPressDec(),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: const InputDecoration(
                    counter: SizedBox.shrink(),
                  ),
                  style: const TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    onTextChanged(text);
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: IconButton(
                  icon: const Icon(Icons.add_box),
                  onPressed: onPressInc(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
