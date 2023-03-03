// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class HedingText extends StatelessWidget {
  HedingText(
    this.text, {
    this.padding,
    super.key,
  });
  String text;
  var padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
    );
  }
}
