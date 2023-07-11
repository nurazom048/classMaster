import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isPhone;
  const SocialLoginButton({
    super.key,
    required this.onTap,
    this.isPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.84,
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 0)
          .copyWith(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0FF),
        borderRadius: BorderRadius.circular(11.13),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              isPhone == true
                  ? FontAwesomeIcons.phone
                  : FontAwesomeIcons.google,
              color: const Color(0xFF0168FF),
              size: 20,
            ),
            const SizedBox(width: 6),
            // Your content here
            Text(
              isPhone == true
                  ? 'Continue with Phone '
                  : "Continue with Google ",
              style: const TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 19 / 14,
                textBaseline: TextBaseline.alphabetic,
                // textAlign: TextAlign.center,
                color: Color(0xFF0168FF),
              ),
            )
          ],
        ),
      ),
    );
  }
}
