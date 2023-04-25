import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  final BuildContext context;
  final Color? color;
  const CrossBar(this.context, {super.key, this.color});

  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: const EdgeInsets.only(top: 0.2),
      alignment: Alignment.centerLeft,
      child: CloseButton(
        onPressed: () => Navigator.pop(context),
        color: color ?? Colors.black,
      ),
    );
  }
}
