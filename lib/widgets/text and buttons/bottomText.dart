// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomText extends StatelessWidget {
  final String text;
  final Color? color;
  dynamic onPressed;
  BottomText(
    this.text, {
    this.color = CupertinoColors.black,
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: CupertinoColors.lightBackgroundGray))),
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: InkWell(
            onTap: onPressed,
            child: Text(text,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color ?? CupertinoColors.activeBlue)),
          ),
          onPressed: onPressed,
        ));
  }
}
