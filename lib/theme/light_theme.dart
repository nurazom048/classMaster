// lib/theme/light_theme.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:classmate/core/constant/app_color.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: AppColor.nokiaBlue,
  fontFamily: 'Open Sans',

  textTheme: TextTheme(
    // headline1: TextStyle(
    //   fontSize: 32,
    //   fontWeight: FontWeight.w700,
    //   color: Colors.black,
    // ),
    // headline6: TextStyle(
    //   fontSize: 24,
    //   fontWeight: FontWeight.w300,
    //   color: Colors.black,
    // ),
    // subtitle1: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.w300,
    //   color: Color(0xFF001D47),
    // ),
    // bodyText1: TextStyle(
    //   fontSize: 16,
    //   fontWeight: FontWeight.w600,
    //   color: AppColor.nokiaBlue,
    // ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontFamily: 'Open Sans',
      fontSize: 24,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
  ),

  iconTheme: const IconThemeData(color: Colors.black),

  cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(),

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
