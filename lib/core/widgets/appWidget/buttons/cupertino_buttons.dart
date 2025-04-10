import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:classmate/core/component/loaders.dart';

class CupertinoButtonCustom extends StatelessWidget {
  const CupertinoButtonCustom({
    required this.text,
    this.widget,
    this.onPressed,
    this.color,
    this.padding,
    this.isLoading,
    this.icon,
    super.key,
  });
  final String text;
  final Widget? widget;
  final dynamic onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final dynamic isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? const EdgeInsets.symmetric(horizontal: 1),
      child: isLoading == true
          ? Loaders.center()
          : CupertinoButton(
              color: color ??
                  const Color(
                      0xFF666666), // Set the background color to #666666
              borderRadius: BorderRadius.circular(11.13),

              onPressed: onPressed,
              child: widget ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$text  ",
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),

                      Icon(
                        icon ?? Icons.arrow_forward,
                        color: CupertinoColors.white,
                        size: 16.0,
                      ), // Replace with the desired right icon
                    ],
                  ),
            ),
    );
  }
}
