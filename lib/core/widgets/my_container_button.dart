// ignore_for_file: deprecated_member_use

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
    super.key,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color.fromRGBO(1, 104, 255, 0.15)
                : const Color.fromRGBO(1, 104, 255, 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromRGBO(1, 104, 255, 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color ?? theme.textTheme.bodyLarge?.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: (color ?? theme.textTheme.bodyLarge?.color)?.withOpacity(0.5) 
                    ?? Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
