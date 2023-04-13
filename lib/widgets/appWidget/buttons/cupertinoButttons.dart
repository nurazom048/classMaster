import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoButtonCustom extends StatelessWidget {
  const CupertinoButtonCustom({
    required this.textt,
    this.widget,
    this.onPressed,
    this.color,
    this.padding,
    super.key,
  });
  final String textt;
  final Widget? widget;
  final dynamic onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: padding ?? EdgeInsets.symmetric(horizontal: size.width * 0.36),

      color: color ??
          const Color(0xFF666666), // Set the background color to #666666
      borderRadius: BorderRadius.circular(11.13),

      onPressed: onPressed,
      child: widget ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$textt  ",
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),

              const Icon(
                Icons.arrow_forward,
                color: CupertinoColors.white,
                size: 16.0,
              ), // Replace with the desired right icon
            ],
          ),
    );
  }
}
