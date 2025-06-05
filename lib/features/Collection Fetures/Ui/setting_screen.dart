// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types

import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/export_core.dart';
import '../../../theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

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

    return SafeArea(
      child: Scaffold(
        body: themeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data:
              (currentTheme) => SingleChildScrollView(
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
                              'General',
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
                            onTap:
                                () => Get.to(
                                  () => const ChangePasswordPage(),
                                  transition: Transition.rightToLeft,
                                ),
                          ),
                          SeatingOption(
                            title: 'Theme',
                            subtitle: getCurrentThemeName(currentTheme),
                            icon: Icons.nightlight_sharp,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Select Theme'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          ThemeModeOption.values.map((mode) {
                                            return RadioListTile<
                                              ThemeModeOption
                                            >(
                                              title: Text(
                                                getCurrentThemeName(mode),
                                              ),
                                              value: mode,
                                              groupValue: currentTheme,
                                              onChanged: (
                                                ThemeModeOption? value,
                                              ) {
                                                if (value != null) {
                                                  themeNotifier.setThemeMode(
                                                    value,
                                                  );
                                                  Navigator.of(
                                                    dialogContext,
                                                  ).pop();
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
                              // Add your notification settings logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
