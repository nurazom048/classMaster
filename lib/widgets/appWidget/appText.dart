import 'package:flutter/material.dart';

class BoldText extends Text {
  BoldText(
    String data, {
    Key? key,
    TextStyle? style,
  }) : super(
          data,
          key: key,
          style: style?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
  read_text() {
    style?.copyWith(fontSize: 32);
    return BoldText(data!);
  }
}

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.title,
    this.color,
  });

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        height: 1.3, // This sets the line height to 22px (16px * 1.3)
        color: color ??
            const Color(
                0xFF0168FF), // This sets the color to Nokia Pure Blue (#0168FF)
      ),
    );
  }
}
