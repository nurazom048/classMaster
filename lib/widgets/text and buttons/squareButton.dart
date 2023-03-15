import 'package:flutter/material.dart';

class SqureButton extends StatelessWidget {
  final IconData icon;
  final IconData? inActiveIcon;
  final String text;
  final String? inActiveText;
  final bool? status;
  final Color? color;
  final dynamic ontap;
  const SqureButton({
    required this.icon,
    this.inActiveIcon,
    required this.text,
    this.inActiveText,
    this.status = false,
    this.ontap,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap ?? () {},
      child: Container(
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
              status == false ? icon : inActiveIcon,
              color: status == false
                  ? color ?? Colors.blue.shade400
                  : Colors.black12,
              size: 36,
            ),
            Text(
              inActiveText == null
                  ? text
                  : status == true
                      ? text
                      : inActiveText!,
              style: TextStyle(
                color: status == false
                    ? color ?? Colors.blue.shade400
                    : Colors.black12,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
