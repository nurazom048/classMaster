// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types

import 'package:classmate/core/component/heder%20component/transition/right_to_Left_transition.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../core/export_core.dart';
import '../../../theme/app_theme.dart';
import '../utils/show_theme_selection_dialog.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

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
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).pushNamed(RouteConst.editAccount);
                            },
                          ),
                          SeatingOption(
                            title: 'Change password',
                            icon: Icons.lock,
                            onTap: () {
                              Navigator.push(
                                context,
                                RightToLeftTransition(
                                  page: const ChangePasswordPage(),
                                ),
                              );
                            },
                          ),
                          SeatingOption(
                            title: 'Theme',
                            subtitle: getCurrentThemeName(currentTheme),
                            icon: Icons.nightlight_sharp,
                            onTap: () {
                              showThemeSelectionDialog(
                                context: context,
                                currentTheme: currentTheme,
                                themeNotifier: themeNotifier,
                                getThemeName: getCurrentThemeName,
                              );
                            },

                            //
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
