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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 650;
    
    // Choose a responsive width with a maximum constraint
    final double buttonWidth = isMobile 
        ? (size.width * 0.85).clamp(280.0, 360.0) 
        : 400.0;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: SizedBox(
          width: buttonWidth,
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
        ),
      ),
    );
  }
}
