// lib/theme/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:classmate/core/constant/app_color.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: AppColor.nokiaBlue,
  fontFamily: 'Open Sans',

  // textTheme: const TextTheme(
  //   // bodyText1: TextStyle(color: Colors.white),
  //   // bodyText2: TextStyle(color: Colors.white70),
  // ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontFamily: 'Open Sans',
      fontSize: 24,
      fontWeight: FontWeight.w300,
      color: Colors.white,
    ),
  ),

  iconTheme: const IconThemeData(color: Colors.white),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.nokiaBlue,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Open Sans',
      ),
    ),
  ),
);
