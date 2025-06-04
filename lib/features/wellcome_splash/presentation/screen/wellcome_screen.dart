// lib/features/wellcome_splash/presentation/screen/wellcome_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../../core/constant/image_const.dart';
import '../../../../core/export_core.dart'; // Contains AppColor, TS (TextStyle helper)
import '../../../authentication_fetures/presentation/screen/LogIn_Screen.dart';

class WellComeScreen extends StatelessWidget {
  const WellComeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // It's good practice to get theme-related properties within the build method,
    // as the theme can change dynamically.
    // final Brightness currentBrightness = Theme.of(context).brightness; // Example if needed

    return WillPopScope(
      // Prevents the user from accidentally navigating back from the welcome screen.
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          // The Scaffold's background color will automatically adapt to the theme
          // (Theme.of(context).scaffoldBackgroundColor) as it's not explicitly set here.
          body: Column(
            children: [
              // HeaderTitle is a custom widget. It might require its own internal theme adjustments
              // if it uses hardcoded colors. This review focuses on `wellcome_screen.dart`.
              // "Wellcome" was corrected to "Welcome" for proper spelling and consistency.
              HeaderTitle("Welcome", context, hideArrow: true),
              const Spacer(flex: 2), // Responsive spacing.
              SizedBox(
                height: 200,
                // The SvgPicture.asset is assumed to be theme-neutral (e.g., uses `currentColor` or is mono-color)
                // or designed to work well on both light and dark backgrounds.
                // If not, different SVG assets might be needed based on the theme.
                child: SvgPicture.asset(ImageConst.wellcome),
              ),
              const Spacer(flex: 4), // More responsive spacing.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome', // Main title text.
                      // The original style `TS.opensensBlue` likely defines font family and base size.
                      // `.copyWith` is used to override the text color to be theme-dependent,
                      // ensuring it contrasts with the background.
                      style: TS.opensensBlue(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ).copyWith(color: Theme.of(context).textTheme.displaySmall?.color), // Use theme-aware color.
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5), // Spacing between title and subtitle.
                  Container(
                    width: MediaQuery.of(context).size.width - 160, // Constrained width for readability.
                    alignment: Alignment.center,
                    child: Text(
                      'Get all your routines and notices in one place!', // Subtitle text.
                      // The original TextStyle properties (fontFamily, fontWeight, fontSize) are preserved.
                      // `.copyWith` overrides the color to be theme-dependent.
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        // The 'height' property (line height) is kept if it's a specific design choice.
                        // height: 65.37 / 48,
                      ).copyWith(color: Theme.of(context).textTheme.titleMedium?.color), // Use theme-aware color.
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50), // Spacing before the button.
                ],
              )
            ],
          ),
          bottomNavigationBar: Container(
            // Margin for the bottom navigation bar container.
            margin: const EdgeInsets.only(bottom: 40),
            child: CupertinoButtonCustom(
              text: "Let’s go", // Button text.
              padding: const EdgeInsets.symmetric(horizontal: 25), // Button padding.
              // Set button background color to the theme's primary color for consistency and adaptability.
              color: Theme.of(context).colorScheme.primary,
              // It's assumed that `CupertinoButtonCustom` either has a fixed text color
              // that contrasts well with `Theme.of(context).colorScheme.primary` (e.g., white),
              // or it internally adapts its text color based on the brightness of its background color.
              // If not, `CupertinoButtonCustom` might need a `textStyle` property or further modification.
              onPressed: () {
                // Navigate to the LoginScreen using GetX.
                Get.to(
                  () => const LoginScreen(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
