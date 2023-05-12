import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class WeekdayTime {
  final int weekday;
  final List<DateTime> times;

  WeekdayTime({required this.weekday, required this.times});
}

///
class LocalNotification {
  // Schedule notifications based on the provided weekday and time information
  static void scheduleNotifications(
      BuildContext context, List<WeekdayTime> weekdayTimes) async {
    // ignore: avoid_print
    print("${DateTime.now()}");

    for (int i = 0; i < weekdayTimes.length; i++) {
      WeekdayTime weekdayTime = weekdayTimes[i];
      int weekday = weekdayTime.weekday;
      List<DateTime> times = weekdayTime.times;

      // Schedule notifications for each specified time on the given weekday
      for (int j = 0; j < times.length; j++) {
        DateTime time = times[j];

        // Calculate the notification's date and time
        DateTime notificationDateTime = DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - weekday))
            .add(Duration(hours: time.hour, minutes: time.minute));

        // Schedule the notification
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i * times.length + j + 1,
            channelKey: 'basic_channel',
            title: 'Notification',
            body:
                'This is a scheduled notification for $weekday at ${time.toString()}',
            notificationLayout: NotificationLayout.Default,
            payload: {'data': 'notification_${i * times.length + j}'},
          ),
          schedule: NotificationCalendar(
            weekday: time.weekday,
            minute: notificationDateTime.minute,
            //   day: DateTime.now().day,
            //   //weekday: DateTime.now().weekday,
            //   // hour: notificationDateTime.hour,
            //   // minute: notificationDateTime.minute,
            // second: 0,
            //   // millisecond: 0,
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
}
