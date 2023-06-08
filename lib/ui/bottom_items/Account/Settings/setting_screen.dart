// ignore_for_file: must_be_immutable// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table/ui/bottom_items/Account/widgets/setting_options.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../../auth_Section/auth_ui/change_password.dart';
import '../utils/settings_utils.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: () {},
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
                    onTap: () => SettingsUtils.showThemeSelectionSheet(
                        context, "themechanger")),

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
                const SeetingOption(
                  title: 'Notification settings',
                  icon: Icons.notifications,
                  onTap: null,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
