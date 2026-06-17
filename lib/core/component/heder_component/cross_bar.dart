// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  final BuildContext context;
  final dynamic ontap;
  final Color? color;
  const CrossBar(this.context, {super.key, this.color, this.ontap});

  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: const EdgeInsets.only(top: 0.2),
      alignment: Alignment.centerLeft,
      child: CloseButton(
        onPressed: ontap ?? () => Navigator.pop(context),
        color: color ?? Colors.black,
      ),
    );
  }
}
