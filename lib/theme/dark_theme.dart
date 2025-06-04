// lib/theme/dark_theme.dart
import 'package:flutter/material.dart';
import 'package:classmate/core/constant/app_color.dart'; // Path to app-specific color constants

// Define dark theme specific colors. These can be new, variations of existing light theme colors, or standard Material dark colors.
final Color darkPrimaryColor = AppColor.nokiaBlue; // Using Nokia Blue, but could be a darker shade for better contrast in dark mode.
final Color darkScaffoldBackgroundColor = Color(0xFF121212); // Standard Material Design dark theme background color.
final Color darkSurfaceColor = Color(0xFF1E1E1E); // Standard Material Design dark theme surface color (for cards, dialogs, etc.).

// Defines the dark theme data for the application.
final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark, // Explicitly set brightness to dark.
    primaryColor: darkPrimaryColor, // Primary color for the dark theme.
    scaffoldBackgroundColor: darkScaffoldBackgroundColor, // Scaffold background for dark theme.
    colorScheme: ColorScheme.dark(
        primary: darkPrimaryColor, // Main primary color.
        secondary: darkPrimaryColor, // Main accent color, can be different if needed for dark theme.
        background: darkScaffoldBackgroundColor, // Background for scaffold and large areas.
        surface: darkSurfaceColor, // Surface color for components like cards, dialogs.
        onPrimary: Colors.white, // Text/icon color that contrasts with the primary color (darkPrimaryColor).
        onSecondary: Colors.white, // Text/icon color that contrasts with the secondary color.
        onBackground: Colors.white, // Text/icon color that contrasts with the background color.
        onSurface: Colors.white, // Text/icon color that contrasts with the surface color.
        error: Colors.redAccent, // Error color for dark theme, typically a lighter shade of red.
        onError: Colors.black, // Text/icon color that contrasts with the error color.
        brightness: Brightness.dark, // Ensures the color scheme is for dark mode.
    ),
    appBarTheme: AppBarTheme(
        color: darkPrimaryColor, // App bar background color for dark theme.
        iconTheme: IconThemeData(color: Colors.white), // Color for icons on the app bar.
        // Styling for text within the app bar's toolbar.
        toolbarTextStyle: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ).bodyMedium,
        // Styling for the main title text in the app bar.
        titleTextStyle: TextTheme(
            titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ).titleLarge,
    ),
    buttonTheme: ButtonThemeData(
        buttonColor: darkPrimaryColor, // Default background color for buttons.
        textTheme: ButtonTextTheme.primary, // Ensures button text (typically light) contrasts with buttonColor.
        // Ensure button color scheme matches the dark theme context.
        colorScheme: ColorScheme.dark(
          primary: darkPrimaryColor,
          brightness: Brightness.dark, // Explicitly set brightness for button's colorScheme
        ),
    ),
    // Placeholder for additional dark theme customizations.
    // e.g., textTheme, inputDecorationTheme, etc.
);
