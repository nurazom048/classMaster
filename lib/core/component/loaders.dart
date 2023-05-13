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
}
