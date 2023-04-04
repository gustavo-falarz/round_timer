import 'package:flutter/material.dart';

class DecIcon extends StatelessWidget {
  const DecIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.indeterminate_check_box, color: Colors.white);
  }
}

class IncIcon extends StatelessWidget {
  const IncIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.add_box, color: Colors.white);
  }
}
