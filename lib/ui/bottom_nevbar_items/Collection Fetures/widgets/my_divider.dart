import 'package:flutter/material.dart';

/// ************MyDividerr************** */
class MyDividerr extends StatelessWidget {
  final double? thickness;
  final double? height;
  final dynamic toppadding;
  final dynamic buttompadding;

  const MyDividerr(
      {this.thickness = 0.5,
      this.height = 0.5,
      this.toppadding = 15.00,
      this.buttompadding = 15.00,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: toppadding, bottom: buttompadding, left: 22.0, right: 22.0),
      child: Divider(
        color: Colors.black45,
        height: height,
        thickness: 0.5,
      ),
    );
  }
}
