import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DotedDivider extends StatelessWidget {
  const DotedDivider({
    this.dashColor,
    this.padding,
    super.key,
  });
  final Color? dashColor;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DottedLine(
        dashColor: dashColor ?? Colors.black,
        dashGapLength: 5,
        dashLength: 5,
        lineThickness: 1,
        direction: Axis.horizontal,
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key, this.padding});
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: const Divider(
        thickness: 1,
        height: 1,
        color: Colors.black,
        // indent: 25,
        //endIndent: 25,
      ),
    );
  }
}
