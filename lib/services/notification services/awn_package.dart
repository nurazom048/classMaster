//import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../constant/logo_const.dart';
import '../../widgets/appWidget/app_text.dart';
import '../one signal/onesignla.services.dart';

class AwesomeNotificationSetup {
// initialize

  static void initialize() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Channel',
          channelDescription: 'Routine And Class Notifications',
          defaultColor: Colors.blue,
          ledColor: Colors.blue,
          playSound: true,
          importance: NotificationImportance.Max,
          locked: true,
          //channelShowBadge: true,
        ),
      ],
      debug: true,
    );
    //  AwesomeNotifications().actionStream.listen((receivedAction) {
    //         var payload = receivedAction.payload;

    //         if(receivedAction.channelKey == 'basic_channel'){
    //           //do something here

    //         }
    //       });
    // AwesomeNotifications().setListeners
    //   await AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: onActionReceivedMethod,
    //     // onNotificationCreatedMethod: onNotificationCreatedMethod,
    //     // onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    //     // onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    //   );
    // }

    //   //
    //   /// Use this method to detect when the user taps on a notification or action button
    //   static Future<void> onActionReceivedMethod(
    //       ReceivedAction receivedAction) async {
    //     debugPrint('onActionReceivedMethod');
    //   });
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
              content: Text(
                'Our app would like to send you notifications. It will notify you before your class starts.',
                style: TS.opensensBlue(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    //one signal permiton
                    OneSignalServices.oneSignalPermission();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //one signal permiton
                    OneSignalServices.oneSignalPermission();
                    //awesome notification permiton
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
