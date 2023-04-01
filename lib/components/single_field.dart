import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class SingleField extends StatelessWidget {
  final Function onTextChanged;
  final String label;

  const SingleField({
    super.key,
    required this.onTextChanged,
    required this.label,
  });

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

  onPressDec() {}

  onPressInc() {}
}
