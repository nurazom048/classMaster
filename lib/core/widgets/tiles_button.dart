//*************TilesButton************************ */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TilesButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final dynamic onTap;
  final String saxpath;
  final EdgeInsetsGeometry? imageMargin;
  final double? width;
  final double? height;

  const TilesButton(
    this.text,
    this.icon, {
    super.key,
    this.onTap,
    required this.saxpath,
    this.imageMargin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 650;
    final double buttonWidth = width ?? (isMobile
        ? ((size.width - 52) / 2).clamp(110.0, 160.0)
        : 150.0);
        
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: height != null ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
        width: buttonWidth,
        height: height ?? 174,
        decoration: BoxDecoration(
          color: isDarkMode 
              ? const Color.fromRGBO(1, 104, 255, 0.15)
              : const Color.fromRGBO(1, 104, 255, 0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(1, 104, 255, 0.15),
            width: 1,
          ),
        ),
        child: Padding(
          padding: height != null 
              ? const EdgeInsets.symmetric(vertical: 2)
              : const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                  Padding(
                    padding: height != null 
                        ? const EdgeInsets.all(2.0)
                        : const EdgeInsets.all(4.0),
                    child: Container(
                      margin: imageMargin,
                      height: (height ?? 174) * 0.40,
                      child: Center(
                        child: SvgPicture.asset(
                          saxpath,
                          height: (height ?? 174) * 0.40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height != null ? 4 : 8),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
