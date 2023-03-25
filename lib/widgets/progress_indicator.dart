// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class Progressindicator extends StatelessWidget {
  final double? h;
  final double? w;
  const Progressindicator({
    this.h,
    this.w,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: h ?? 250,
        width: w ?? 220,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
