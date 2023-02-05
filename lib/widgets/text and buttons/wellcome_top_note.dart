import 'package:flutter/material.dart';

class WellComeTopHeder extends StatelessWidget {
  dynamic alignment;
  String title, subtitle;
  WellComeTopHeder({
    required this.alignment,
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      // margin: const EdgeInsets.only(left: 20),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800])),
            TextSpan(
                text: '\n$subtitle',
                style: const TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
