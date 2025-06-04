// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'light_theme.dart'; // Import the defined light theme
import 'dark_theme.dart'; // Import the defined dark theme

// Key used to store and retrieve the selected theme mode from Hive local storage.
const String _themeModeKey = 'themeMode';

// Enum representing the available theme options for the user.
enum ThemeModeOption {
  light, // Represents the light theme.
  dark,  // Represents the dark theme.
  system // Represents the system's default theme setting.
}

// Notifier for managing app theme state (light, dark, system).
// It handles loading the saved theme preference and updating the theme.
class ThemeNotifier extends ChangeNotifier {
    // Holds the current selected theme mode, defaults to system.
    ThemeModeOption _themeMode = ThemeModeOption.system;

    // Constructor: Initializes the ThemeNotifier and loads the saved theme mode.
    ThemeNotifier() {
        _loadThemeMode();
    }

    // Getter for the current theme mode.
    ThemeModeOption get themeMode => _themeMode;

    // Determines the ThemeData to apply based on the current _themeMode.
    // Note: For ThemeModeOption.system, this currently returns lightTheme as a placeholder.
    // The actual system theme application is handled by MaterialApp's themeMode property.
    ThemeData get currentTheme {
        switch (_themeMode) {
            case ThemeModeOption.light:
                return lightTheme;
            case ThemeModeOption.dark:
                return darkTheme;
            case ThemeModeOption.system:
            // For ThemeModeOption.system, MaterialApp's `themeMode: ThemeMode.system`
            // will correctly apply the light or dark theme based on system settings.
            // This getter is primarily for cases where direct ThemeData is needed
            // and the system theme is not yet resolved by Flutter's own mechanism.
                return lightTheme; // Default to lightTheme if system is chosen but not yet resolved by MaterialApp.
        }
    }

    // Exposes the ThemeData object for the dark theme.
    ThemeData get darkThemeData => darkTheme;
    // Exposes the ThemeData object for the light theme.
    ThemeData get lightThemeData => lightTheme;

    // Sets the application's theme mode and persists the choice to Hive.
    // Notifies listeners to rebuild UI with the new theme.
    Future<void> setThemeMode(ThemeModeOption mode) async {
        if (_themeMode == mode) return; // No change if the mode is already set.
        _themeMode = mode;
        notifyListeners(); // Notify listeners (e.g., UI widgets) about the theme change.

        // Persist theme mode choice using Hive local storage.
        final box = await Hive.openBox('settings'); // Open the 'settings' box.
        await box.put(_themeModeKey, mode.index); // Store the enum index.
    }

    // Loads the saved theme mode from Hive when the app starts.
    // Defaults to system theme if no preference is found or if the stored value is invalid.
    Future<void> _loadThemeMode() async {
        final box = await Hive.openBox('settings');
        final themeIndex = box.get(_themeModeKey) as int?; // Retrieve the stored theme index.
        if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeModeOption.values.length) {
            _themeMode = ThemeModeOption.values[themeIndex]; // Convert index back to enum.
        }
        // Notifying listeners even if the theme hasn't changed from default,
        // to ensure UI consistency on initial load.
        notifyListeners();
    }

    // Helper to convert the app's ThemeModeOption to Flutter's ThemeMode enum.
    // This is used by MaterialApp.router to set its themeMode.
    ThemeMode get flutterThemeMode {
        switch (_themeMode) {
            case ThemeModeOption.light:
                return ThemeMode.light;
            case ThemeModeOption.dark:
                return ThemeMode.dark;
            case ThemeModeOption.system:
            default:
                return ThemeMode.system; // Flutter's way of saying "follow system settings".
        }
    }
}

// Riverpod provider for accessing the ThemeNotifier instance.
// This allows widgets to listen to theme changes and access theme properties.
final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
    return ThemeNotifier(); // Creates and provides an instance of ThemeNotifier.
});
