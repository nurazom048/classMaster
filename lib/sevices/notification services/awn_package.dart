//import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AwsomNotificationSetup {
// initialize

  static void initialize() async {
    if (!kIsWeb) {
      AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Channel',
            channelDescription: 'Basic channel for notifications',
            defaultColor: Colors.blue,
            ledColor: Colors.blue,
          ),
        ],
      );
    }
  }

  //
  static takePermiton(context) {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Routine Notifications'),
              content: const Text(
                  'Our app would like to send you notifications. It will notify you before your class starts.'),
              actions: [
                TextButton(
                  onPressed: () {
                    AppSettings.openNotificationSettings();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((_) => Navigator.pop(context));
                  },
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
