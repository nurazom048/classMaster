import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/core/component/loaders.dart';

class CupertinoButtonCustom extends StatelessWidget {
  const CupertinoButtonCustom({
    required this.textt,
    this.widget,
    this.onPressed,
    this.color,
    this.padding,
    this.isLoding,
    this.icon,
    super.key,
  });
  final String textt;
  final Widget? widget;
  final dynamic onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final dynamic isLoding;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? const EdgeInsets.symmetric(horizontal: 1),
      child: isLoding == true
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
                        "$textt  ",
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
