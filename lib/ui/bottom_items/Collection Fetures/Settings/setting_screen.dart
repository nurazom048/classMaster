// ignore_for_file: must_be_immutable// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, must_be_immutable

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/widgets/heder/heder_title.dart';

import '../../../auth_Section/auth_ui/change_password.dart';
import '../Ui/eddit_account.dart';
import '../widgets/setting_options.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            HeaderTitle("Settings", context),

            //......... Genarel........
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Genarel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SeetingOption(
                    title: 'Edit profile',
                    icon: Icons.person,
                    onTap: () => Get.to(const EdditAccount()),
                  ),

                  SeetingOption(
                    title: 'Change password',
                    icon: Icons.lock,
                    onTap: () => Get.to(
                      () => const ChangePasswordPage(),
                      transition: Transition.rightToLeft,
                    ),
                  ),
                  SeetingOption(
                    title: 'Theem',
                    subtitle: "theme",
                    icon: Icons.nightlight_sharp,
                    // onTap: () => SettingsUtils.showThemeSelectionSheet(
                    //     context, "themechanger")
                    onTap: () => Alert.upcoming(context),
                  ),

                  //......... Notifications........
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
                  SeetingOption(
                    title: 'Notification settings',
                    icon: Icons.notifications,
                    onTap: () => AppSettings.openNotificationSettings(),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
