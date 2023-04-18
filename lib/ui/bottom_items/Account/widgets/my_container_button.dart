import 'package:flutter/material.dart';

/// ************MyContainerButton************** */
class MyContainerButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color? color;

  dynamic onTap;
  MyContainerButton(this.icon, this.text, {Key? key, this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const Spacer(flex: 3),
          icon,
          const Spacer(flex: 2),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            width: size.width / 1.8,
            color: Colors.black12,
            child: Text(
              text,
              style: TextStyle(color: color),
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
