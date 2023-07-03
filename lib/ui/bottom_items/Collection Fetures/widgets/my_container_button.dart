import 'package:flutter/material.dart';

/// ************MyContainerButton************** */

class MyContainerButton extends StatelessWidget {
  final Widget? icon;
  final String text;
  final Color? color;

  final VoidCallback onTap;

  const MyContainerButton(
    this.icon,
    this.text, {
    this.color,
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          const Spacer(flex: 3),
          icon ?? const SizedBox.shrink(),
          const Spacer(flex: 2),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            width: size.width / 1.8,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(1, 104, 255, 0.10),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              text,
              textScaleFactor: 1.1,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
