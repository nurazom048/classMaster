import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

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

//______________TS_____________________//
class TS {
// open sens blue
  static TextStyle opensensBlue(
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Open Sans',
      fontStyle: FontStyle.normal,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontSize: fontSize ?? 16.0,
      height: 1.3,
      color: color ?? AppColor.nokiaBlue,
    );
  }
}
