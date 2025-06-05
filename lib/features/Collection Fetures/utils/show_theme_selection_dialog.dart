import 'package:flutter/material.dart';
import 'package:classmate/theme/app_theme.dart'
    show ThemeModeOption, ThemeNotifier;

Future<void> showThemeSelectionDialog({
  required BuildContext context,
  required ThemeModeOption currentTheme,
  required ThemeNotifier themeNotifier,
  required String Function(ThemeModeOption) getThemeName,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      ThemeModeOption tempTheme = currentTheme;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ThemeModeOption.values.map((mode) {
                    return RadioListTile<ThemeModeOption>(
                      title: Text(getThemeName(mode)),
                      value: mode,
                      groupValue: tempTheme,
                      onChanged: (ThemeModeOption? value) async {
                        if (value != null) {
                          setState(() => tempTheme = value);
                          await themeNotifier.setThemeMode(value);
                          if (context.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        }
                      },
                    );
                  }).toList(),
            ),
          );
        },
      );
    },
  );
}

String getCurrentThemeName(ThemeModeOption themeMode) {
  switch (themeMode) {
    case ThemeModeOption.light:
      return "Light";
    case ThemeModeOption.dark:
      return "Dark";
    case ThemeModeOption.system:
      return "System";
  }
}
