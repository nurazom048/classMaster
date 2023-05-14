import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../models/class_details_model.dart';

// class WeekdayTime {
//   final int weekday;
//   final List<Day> times;

//   WeekdayTime({required this.weekday, required this.times});
// }

///
class LocalNotification {
  // Schedule notifications based on the provided weekday and time information
  static void scheduleNotifications(
      BuildContext context, List<Day?> weekdayTimes) async {
    // ignore: avoid_print
    print("${DateTime.now()}");

    for (int i = 0; i < weekdayTimes.length; i++) {
      // WeekdayTime weekdayTime = weekdayTimes[i];
      int weekday = weekdayTimes[i]?.num ?? 0;

      // Schedule the notification
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'basic_channel',
          title: 'Class Start ${weekdayTimes[i]?.classId.name}',
          body:
              'This is a scheduled notification for $weekday at ${weekdayTimes[i]?.num}',
          notificationLayout: NotificationLayout.Default,
          payload: {'data': 'notification_'},
        ),
        schedule: NotificationCalendar(
          // weekday: weekdayTimes[i].weekday,
          minute: weekdayTimes[i]?.startTime.hour,
          // minute: DateTime.now().toLocal().minute + 1
          // repeats: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'dismiss',
            label: 'Dismiss',
          ),
        ],
      );
    }
  }
}
