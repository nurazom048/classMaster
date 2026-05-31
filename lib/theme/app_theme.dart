// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'light_theme.dart'; // Import the defined light theme
import 'dark_theme.dart'; // Import the defined dark theme

enum ThemeModeOption { light, dark, system }

const _themeModeKey = 'themeMode';

class ThemeNotifier extends AsyncNotifier<ThemeModeOption> {
  @override
  Future<ThemeModeOption> build() async {
    // SharedPreferences বা লোকাল স্টোরেজ থেকে সেভ করা থিম রিড করার লজিক
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_mode');

    if (savedTheme == 'dark') {
      return ThemeModeOption.dark;
    } else if (savedTheme == 'system') {
      return ThemeModeOption.system;
    }

    // যদি আগে থেকে কোনো থিম সেভ করা না থাকে, তবে ডিফল্ট হিসেবে Light রিটার্ন করবে
    return ThemeModeOption.light;
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    final box = await Hive.openBox('settings');
    await box.put(_themeModeKey, mode.index);
    state = AsyncValue.data(mode);
  }

  ThemeMode get flutterThemeMode {
    return switch (state.value) {
      ThemeModeOption.light => ThemeMode.light,
      ThemeModeOption.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  final ThemeData lightTheme = ThemeData.light();
  final ThemeData darkTheme = ThemeData.dark();

  ThemeData get currentTheme {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final mode = state.value ?? ThemeModeOption.system;

    return switch (mode) {
      ThemeModeOption.light => lightTheme,
      ThemeModeOption.dark => darkTheme,
      ThemeModeOption.system =>
        brightness == Brightness.dark ? darkTheme : lightTheme,
    };
  }
}

final themeNotifierProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeModeOption>(ThemeNotifier.new);
