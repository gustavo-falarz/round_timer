import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:round_timer/components/icons.dart';

import '../constants.dart';

class SingleField extends StatelessWidget {
  final Function onTextChanged;
  final String label;
  final int initialValue;

  SingleField({
    super.key,
    required this.onTextChanged(int value),
    required this.label,
    required this.initialValue,
  });

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue.toString();

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
                padding: const EdgeInsets.only(right: 35),
                child: IconButton(
                  onPressed: onPressDec,
                  icon: const DecIcon(),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    counter: SizedBox.shrink(),
                  ),
                  style: const TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      onTextChanged(int.parse(text));
                    }
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: IconButton(
                  onPressed: onPressInc,
                  icon: const IncIcon(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  onPressDec() {
    var value = int.parse(_controller.text);
    value = value - 1;
    _controller.text = value.toString();
    onTextChanged(value);
  }

  onPressInc() {
    var value = int.parse(_controller.text);
    value = value + 1;
    _controller.text = value.toString();
    onTextChanged(value);
  }
}
