// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types

import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../core/export_core.dart';
import '../../../theme/app_theme.dart';
import '../utils/show_theme_selection_dialog.dart';

import 'package:flutter/foundation.dart';
import 'package:classmate/services/notification_services/awn_package.dart';
import 'package:classmate/services/notification_services/local_notification/web/web_notification_helper.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return  SafeArea(
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
                              context.pushNamed(RouteConst.passwordChange);
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
                          const NotificationStatusTile(),
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

class NotificationStatusTile extends StatefulWidget {
  const NotificationStatusTile({super.key});

  @override
  State<NotificationStatusTile> createState() => _NotificationStatusTileState();
}

class _NotificationStatusTileState extends State<NotificationStatusTile> {
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() {
    if (kIsWeb) {
      setState(() {
        isGranted = WebNotificationHelper.isPermissionGranted();
      });
    } else {
      setState(() {
        isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String platformName = kIsWeb ? "Web Browser" : "Android Device";
    final String statusText = isGranted ? "Allowed / Active" : "Not Allowed (Tap to enable)";
    final Color statusColor = isGranted ? Colors.teal : Colors.orange.shade800;
    final IconData statusIcon = isGranted ? Icons.check_circle : Icons.warning_amber_rounded;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.12),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          "$platformName Notifications",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text(
                "Status: ",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          AwesomeNotificationSetup.takePermission(context);
          await Future.delayed(const Duration(milliseconds: 500));
          _checkPermission();
        },
      ),
    );
  }
}
