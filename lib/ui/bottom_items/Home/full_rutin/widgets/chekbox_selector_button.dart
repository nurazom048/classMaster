import 'package:flutter/material.dart';

class ChackBoxSelector extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String text;
  final bool? isChacked;
  final VoidCallback onTap;
  const ChackBoxSelector({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.isChacked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        height: 40,
        child: Row(
          children: [
            if (isChacked != null)
              Icon(isChacked == true
                  ? Icons.check
                  : Icons.check_box_outline_blank_rounded),
            const SizedBox(width: 10),
            Icon(icon),
            const SizedBox(width: 10),
            Text(text, style: TextStyle(color: color ?? Colors.black)),
          ],
        ),
      ),
    );
  }
}
