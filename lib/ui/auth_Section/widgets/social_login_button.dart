import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const SocialLoginButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 43.84,
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0FF),
        borderRadius: BorderRadius.circular(11.13),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            FaIcon(
              FontAwesomeIcons.google,
              color: Color(0xFF0168FF),
              size: 20,
            ),
            // Your content here
            Text(
              'Continue with Google',
              style: TextStyle(
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
