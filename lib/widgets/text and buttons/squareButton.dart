import 'package:flutter/material.dart';

class SqureButton extends StatelessWidget {
  final IconData icon, inActiveIcon;
  final String text;
  final String? inActiveText;
  final bool? status;
  const SqureButton({
    required this.icon,
    required this.inActiveIcon,
    required this.text,
    this.inActiveText,
    this.status = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0.4,
            blurRadius: 90000,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            status == true ? icon : inActiveIcon,
            color: status == false ? Colors.blue.shade400 : Colors.black12,
            size: 40,
          ),
          Text(
            inActiveText == null
                ? text
                : status == true
                    ? text
                    : inActiveText!,
            style: TextStyle(
                color: status == false ? Colors.blue.shade400 : Colors.black12,
                fontSize: 15),
          )
        ],
      ),
    );
  }
}
