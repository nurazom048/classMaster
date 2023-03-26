import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  BuildContext context;
  CrossBar(this.context, {super.key});

  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.2),
      alignment: Alignment.centerLeft,
      child: CloseButton(onPressed: () => Navigator.pop(context)),
    );
  }
}
