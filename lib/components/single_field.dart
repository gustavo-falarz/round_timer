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
      {this.onPressInc,
      this.onPressDec,
      this.onTextChanged,
      this.controller,
      this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: marginTopTimers),
          child: Center(
            child: Text(label),
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
                  onPressed: onPressDec,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    onTextChanged(text);
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 35),
                child: IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: onPressInc,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
