// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppText {
  final double? fontSize;
  final String data;
  final Color? color;
  const AppText(
    this.data, {
    Key? key,
    this.fontSize,
    this.color,
  });

  //

  ///
  ///
  ///
  heding({FontWeight? fontWeight}) {
    return Text(data,
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontStyle: FontStyle.normal,
          fontWeight: fontWeight ?? FontWeight.w300,
          fontSize: fontSize ?? 20,
          height: 1.27,
          color: color ?? const Color(0xFF333333),
        ));
  }

  //

  title() {
    return Text(
      data,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w300,
        fontSize: fontSize ?? 36,
        color: color ?? Colors.black,
      ),
    );
  }
}


  

// class AppText extends StatelessWidget {
//   const AppText({
//     super.key,
//     required this.title,
//     this.color,
//   });

//   final String title;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontFamily: 'Open Sans',
//         fontStyle: FontStyle.normal,
//         fontWeight: FontWeight.w600,
//         fontSize: 16.0,
//         height: 1.3, // This sets the line height to 22px (16px * 1.3)
//         color: color ??
//             const Color(
//                 0xFF0168FF), // This sets the color to Nokia Pure Blue (#0168FF)
//       ),
//     );
//   }
// }
