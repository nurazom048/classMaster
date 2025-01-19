import 'package:flutter/material.dart';

import '../../export_core.dart';

class DrawerItems extends StatelessWidget {
  final IconData? icon;
  final Widget? widget;
  final String text;
  final dynamic onTap;
  const DrawerItems({
    super.key,
    this.icon,
    required this.text,
    this.widget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const Spacer(flex: 1),
            if (icon != null) Icon(icon),
            widget ?? Container(),
            const Spacer(flex: 1),
            Text(
              text,
              style: TS.opensensBlue(color: Colors.black),
            ),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }
}
