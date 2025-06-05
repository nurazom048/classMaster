import 'package:flutter/material.dart';

/// ************MyDividerr************** */
class MyDividerr extends StatelessWidget {
  final double? thickness;
  final double? height;
  final dynamic topPadding;
  final dynamic bottomPadding;

  const MyDividerr({
    super.key,
    this.thickness = 0.5,
    this.height = 0.5,
    this.topPadding = 15.00,
    this.bottomPadding = 15.00,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: 22.0,
        right: 22.0,
      ),
      child: Divider(color: Colors.black45, height: height, thickness: 0.5),
    );
  }
}
