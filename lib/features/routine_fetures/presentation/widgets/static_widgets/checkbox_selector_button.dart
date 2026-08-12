import 'package:flutter/material.dart';

class CheckBoxSelector extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String text;
  final bool? isChecked;
  final VoidCallback onTap;
  const CheckBoxSelector({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 15),
                  Text(text, style: TextStyle(color: color ?? Colors.black)),
                ],
              ),
              if (isChecked != null)
                Icon(
                  isChecked == true
                      ? Icons.check
                      : Icons.check_box_outline_blank_rounded,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
