// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class Progressindicator extends StatelessWidget {
  const Progressindicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: 220,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 90),
          child: CircularProgressIndicator(),
        ));
  }
}
