import 'package:classmate/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class ShareNoticeButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShareNoticeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF4FC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF0168FF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.share_outlined, color: Color(0xFF0168FF)),
            const SizedBox(width: 8),
            Text(
              "Share Notice",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColor.nokiaBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
