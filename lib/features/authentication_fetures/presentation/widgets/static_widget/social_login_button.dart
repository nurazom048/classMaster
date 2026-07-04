import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:classmate/core/component/loaders.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isLoading;
  final bool? isPhone;
  final String? text;
  final Widget? icon;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialLoginButton({
    super.key,
    required this.onTap,
    this.isPhone,
    this.isLoading,
    this.text,
    this.icon,
    this.margin,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 60, vertical: 0)
          .copyWith(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFE4F0FF),
        borderRadius: BorderRadius.circular(11.13),
      ),
      child: isLoading == true
          ? Loaders.center()
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ??
                      FaIcon(
                        isPhone == true
                            ? FontAwesomeIcons.phone
                            : FontAwesomeIcons.google,
                        color: textColor ?? const Color(0xFF0168FF),
                        size: 20,
                      ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text ??
                          (isPhone == true
                              ? 'Continue with Phone'
                              : "Continue with Google"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: textColor ?? const Color(0xFF0168FF),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
