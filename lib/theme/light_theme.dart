// lib/theme/light_theme.dart
import 'package:flutter/material.dart';
import 'package:classmate/core/constant/app_color.dart'; // Path to app-specific color constants

// Defines the light theme data for the application.
final ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light, // Explicitly set brightness to light
    primaryColor: AppColor.nokiaBlue, // Using primary color from AppColor for consistency
    scaffoldBackgroundColor: AppColor.background, // Using background color from AppColor
    colorScheme: ColorScheme.light(
        primary: AppColor.nokiaBlue, // Main primary color from app_color.dart
        secondary: AppColor.nokiaBlue, // Main accent color, can be different if needed
        background: AppColor.background, // Background for scaffold and large areas from app_color.dart
        surface: Colors.white, // Standard white surface for cards, dialogs, etc.
        onPrimary: Colors.white, // Text/icon color that contrasts with the primary color
        onSecondary: Colors.white, // Text/icon color that contrasts with the secondary color
        onBackground: Colors.black, // Text/icon color that contrasts with the background color
        onSurface: Colors.black, // Text/icon color that contrasts with the surface color
        error: Colors.red, // Standard error color
        onError: Colors.white, // Text/icon color that contrasts with the error color
        brightness: Brightness.light, // Ensures the color scheme is for light mode
    ),
    appBarTheme: AppBarTheme(
        color: AppColor.nokiaBlue, // App bar background color using AppColor
        iconTheme: IconThemeData(color: Colors.white), // Color for icons on the app bar (e.g., back arrow)
        // Styling for text within the app bar's toolbar
        toolbarTextStyle: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ).bodyMedium,
        // Styling for the main title text in the app bar
        titleTextStyle: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ).titleLarge,
    ),
    buttonTheme: ButtonThemeData(
        buttonColor: AppColor.nokiaBlue, // Default background color for buttons using AppColor
        textTheme: ButtonTextTheme.primary, // Ensures button text (typically light) contrasts with buttonColor
    ),
    // Placeholder for additional theme customizations.
    // For example:
    // textTheme: TextTheme(...) to define global text styles (headline1, bodyText1, etc.)
    // inputDecorationTheme: InputDecorationTheme(...) to style text fields.
);
