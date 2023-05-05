// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtomCustom extends StatelessWidget {
  final Widget text;
  final dynamic onPressed;
  const ButtomCustom({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(7),
      onPressed: onPressed,
      child: text,
    );
  }
}
