import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const NotificationButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        height: 30,
        width: 50,
        child: Row(
          children: [
            Icon(icon, color: Colors.black45),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
