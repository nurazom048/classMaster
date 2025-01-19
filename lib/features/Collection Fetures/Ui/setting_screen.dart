// ignore_for_file: must_be_immutable// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, must_be_immutable

import 'package:app_settings/app_settings.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/export_core.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            HeaderTitle("Settings", context),

            //......... Ganarel........
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
                  SeatingOption(
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
