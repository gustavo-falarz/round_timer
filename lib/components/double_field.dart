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
      {this.label,
      this.onPressInc,
      this.onPressDec,
      this.onTextChangedMin,
      this.onTextChangedSec,
      this.minController,
      this.secController});

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
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.indeterminate_check_box),
                  onPressed: onPressDec,
                ),
              ),
            ),
            Flexible(
              child: TextField(
                textAlign: TextAlign.center,
                controller: minController,
                decoration: InputDecoration(counter: SizedBox.shrink()),
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  onTextChangedMin(text);
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(":"),
              ),
            ),
            Flexible(
              child: TextField(
                textAlign: TextAlign.center,
                controller: secController,
                decoration: InputDecoration(counter: SizedBox.shrink()),
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.number,
                maxLength: 2,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  onTextChangedSec(text);
                },
              ),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                      icon: Icon(Icons.add_box), onPressed: onPressInc)),
            ),
          ],
        ),
      ],
    );
  }
}
