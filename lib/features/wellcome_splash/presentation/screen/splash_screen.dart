// lib/features/wellcome_splash/presentation/screen/splash_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constant/png_const.dart'; // Contains ConstPng.logoWithTittle

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Determine the current brightness of the theme (light or dark).
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Logic for choosing the logo based on the current theme.
    // The asset 'assets/logo/white_logo.png' was mentioned as potentially existing for dark mode,
    // but it's not currently referenced in `ConstPng`.
    // For now, `ConstPng.logoWithTittle` is used for both light and dark themes.
    // If `ConstPng.logoWithTittle` is not clearly visible on dark backgrounds,
    // a specific dark theme logo variant should be added to `ConstPng` (e.g., `ConstPng.whiteLogoWithTittle`),
    // and the following logic should be enabled to switch logos:
    /*
    String currentLogo = isDarkMode ? ConstPng.whiteLogoWithTittle : ConstPng.logoWithTittle;
    */
    String currentLogo = ConstPng.logoWithTittle; // Current logo asset, may need a dark theme variant.

    return Scaffold(
      // Set scaffold background to be theme-adaptive, ensuring it matches the current theme.
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 72), // Standard margin for the logo container.
          // The container's original hardcoded 'color: Colors.white' has been removed.
          // This allows the image to be displayed directly on the theme's scaffold background.
          // If a distinct background for the logo container itself were needed (e.g., a card effect),
          // it could be set using a theme-aware color like `Theme.of(context).cardColor`.
          decoration: BoxDecoration(
            image: DecorationImage(
              // Use the selected logo asset.
              image: AssetImage(currentLogo),
            ),
          ),
        ),
      ),
    );
  }
}
