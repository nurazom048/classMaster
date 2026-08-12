import 'package:flutter/material.dart';

class AddWeekdayButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final IconData icon;

  const AddWeekdayButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
