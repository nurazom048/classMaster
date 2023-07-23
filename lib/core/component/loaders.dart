import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loaders {
  //center
  static Widget center({
    final double? height,
    final double? width,
  }) =>
      SizedBox(
        height: height,
        width: width,
        child: const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: RepaintBoundary(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

  static button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          onPressed: () {},
          child: const RepaintBoundary(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
