import 'package:flutter/material.dart';

class ForgetPasswordBtn extends StatelessWidget {
  final dynamic onTap;
  const ForgetPasswordBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          const Text(
            "Forgot your Password ?",

            style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }
}
