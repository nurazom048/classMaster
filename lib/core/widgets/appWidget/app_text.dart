import 'package:flutter/material.dart';

import '../../export_core.dart';

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
  heeding({FontWeight? fontWeight}) {
    return Text(
      data,
      style: TextStyle(
        fontFamily: 'Open Sans',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.w300,
        fontSize: fontSize ?? 20,
        height: 1.27,
        color: color ?? const Color(0xFF333333),
      ),
    );
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
  // Heading

  static TextStyle heading(
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Open Sans',
      fontStyle: FontStyle.normal,
      fontWeight: fontWeight ?? FontWeight.w300,
      fontSize: fontSize ?? 24,
      height: 1.27,
      color: color ?? Colors.black,
    );
  }

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
