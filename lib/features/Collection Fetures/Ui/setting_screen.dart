// lib/features/Collection Fetures/Ui/setting_screen.dart
// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types

import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:get/get.dart';
import '../../../core/export_core.dart';
import '../../../theme/app_theme.dart'; // Added AppTheme import

class SettingsPage extends ConsumerWidget { // Changed to ConsumerWidget
  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    // Watch the themeNotifierProvider to get the current theme state and ThemeNotifier instance.
    // This makes the widget rebuild when the theme mode changes.
    final themeNotifier = ref.watch(themeNotifierProvider);

    // Helper function to convert ThemeModeOption enum to a displayable string.
    String getCurrentThemeName(ThemeModeOption themeMode) {
      switch (themeMode) {
        case ThemeModeOption.light:
          return "Light"; // Display name for light theme
        case ThemeModeOption.dark:
          return "Dark";  // Display name for dark theme
        case ThemeModeOption.system:
        default:
          return "System"; // Display name for system default theme
      }
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeaderTitle("Settings", context),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'General', // Corrected typo from 'Ganarel' to 'General'
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SeatingOption(
                      title: 'Edit profile',
                      icon: Icons.person,
                      onTap: () => Get.to(const EditAccount()),
                    ),
                    SeatingOption(
                      title: 'Change password',
                      icon: Icons.lock,
                      onTap: () => Get.to(
                            () => const ChangePasswordPage(),
                            transition: Transition.rightToLeft,
                          ),
                    ),
                    SeatingOption(
                      title: 'Theme',
                      // Display the currently selected theme name as the subtitle.
                      subtitle: getCurrentThemeName(themeNotifier.themeMode),
                      icon: Icons.nightlight_sharp, // Icon representing theme settings.
                      onTap: () {
                        // Show a dialog to allow the user to select a new theme mode.
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Select Theme'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min, // Keep dialog content compact.
                                // Create a RadioListTile for each available theme mode.
                                children: ThemeModeOption.values.map((mode) {
                                  return RadioListTile<ThemeModeOption>(
                                    title: Text(getCurrentThemeName(mode)), // Display theme mode name.
                                    value: mode, // The value this radio button represents.
                                    groupValue: themeNotifier.themeMode, // The currently selected theme mode.
                                    // Called when the user selects this radio button.
                                    onChanged: (ThemeModeOption? value) {
                                      if (value != null) {
                                        // Update theme mode via ThemeNotifier and persist the change.
                                        ref.read(themeNotifierProvider.notifier).setThemeMode(value);
                                        Navigator.of(dialogContext).pop(); // Close the dialog after selection.
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SeatingOption(
                      title: 'Notification settings',
                      icon: Icons.notifications,
                      onTap: () {
                        // AppSettings.openNotificationSettings(); // Kept original commented out
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
