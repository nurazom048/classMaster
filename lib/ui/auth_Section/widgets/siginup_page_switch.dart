import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';

class SiginUpSuicherButton extends StatelessWidget {
  final String starttitle;
  final String endtitle;
  final dynamic onTap;
  const SiginUpSuicherButton(
    this.starttitle,
    this.endtitle, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          starttitle,
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
          child: Text(' $endtitle', style: TS.opensensBlue()),
        )
      ],
    );
  }
}
