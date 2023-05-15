// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';

class HeddingRow extends StatelessWidget {
  final String hedding;
  final String? secondHeading;
  final String? buttonText;
  final dynamic onTap;
  final double? paddingTop;
  final EdgeInsetsGeometry? margin;

  const HeddingRow({
    required this.hedding,
    this.secondHeading = "",
    this.paddingTop,
    this.onTap,
    this.buttonText,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hedding,
                style: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  height: 19.07 / 14.0,
                  color: Color(0xFF0168FF),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                secondHeading ?? '',
                style: const TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.33,
                    color: Color(0xffa7a7a7)),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          if (buttonText != null)
            CapsuleButton(
              buttonText ?? '',
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}
