import 'package:flutter/material.dart';

/// *************AppbarCustom***************************/
class AppbarCustom extends StatelessWidget {
  String title;
  dynamic ontap;
  double? size;
  IconData? ledingicon;
  Widget? actionIcon;
  double buttompadding;
  double toppadding;
  AppbarCustom({
    this.ontap,
    this.ledingicon,
    required this.title,
    this.size,
    this.buttompadding = 7.0,
    this.toppadding = 15.0,
    this.actionIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: toppadding, bottom: buttompadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          InkWell(
              onTap: ontap ?? (() => Navigator.pop(context)),
              child: Icon(ledingicon ?? Icons.clear, size: 27.0)),
          Text("   $title",
              style: TextStyle(
                  fontSize: size ?? 20.0, fontWeight: FontWeight.w800)),
          const Spacer(flex: 20),
          actionIcon ?? Container(),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
