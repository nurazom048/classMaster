import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';

class SignUpSwitcherButton extends StatelessWidget {
  final String startTitle;
  final String endTitle;
  final dynamic onTap;
  const SignUpSwitcherButton(
    this.startTitle,
    this.endTitle, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          startTitle,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            height: 1.28,
            color: Colors.black,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Text(' $endTitle', style: TS.opensensBlue()),
        )
      ],
    );
  }
}
