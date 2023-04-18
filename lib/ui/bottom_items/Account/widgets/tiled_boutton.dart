//*************TilesButton************************ */

import 'package:flutter/material.dart';

class Tilesbutton extends StatelessWidget {
  String text;

  Widget icon;

  dynamic onTap;

  Tilesbutton(this.text, this.icon, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.all(5),
        width: size.height / 8,
        height: size.height / 8,
        color: Colors.black45,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon,
          const SizedBox(height: 3),
          Text(text),
        ]),
      ),
    );
  }
}
