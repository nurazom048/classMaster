import 'package:flutter/material.dart';
import 'routine_theme.dart';

class RoutineBottomBar extends StatelessWidget {
  final RoutineTheme theme;
  final VoidCallback onSharePressed;
  final VoidCallback onNotifyPressed;

  const RoutineBottomBar({
    super.key,
    required this.theme,
    required this.onSharePressed,
    required this.onNotifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left Button: Share Routine (Outlined)
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onSharePressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.ios_share_rounded,
                    color: Color(0xFF334155),
                    size: 18,
                  ),
                  label: const Text(
                    "Share Routine",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Right Button: Notify Me (Filled)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onNotifyPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Notify Me",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
