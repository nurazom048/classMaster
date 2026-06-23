// Reusable Static Wrapper for Authentication Screens
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StaticAuthScreen extends StatelessWidget {
  final Widget child;
  final String imagePath;
  const StaticAuthScreen({
    super.key,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 768;
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEF),
      body: Center(
        // Padding added around the container for smaller screens
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            // Reduced width and height to make the card more compact
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(maxWidth: 850),
            height: isDesktop ? 500 : null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              children: [
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Container(
                    height: isDesktop ? double.infinity : 250,
                    color: const Color(0xFFF7F6F1),
                    child: Center(
                      // Scaled down the image slightly to match the new compact size
                      child: SvgPicture.asset(
                        imagePath,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 30,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
