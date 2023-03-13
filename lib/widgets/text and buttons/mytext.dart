import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const MyText(
    this.text, {
    this.color,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 8.0, bottom: 3),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color ?? Colors.black,
              fontFamily: 'Roboto')),
    );
  }
}
