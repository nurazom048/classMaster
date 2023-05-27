import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loaders {
  //center
  static Widget center() => const Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(),
        ),
      );

  static button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          onPressed: () {},
          child: const CircularProgressIndicator(),
        ),
      ],
    );
  }
}
