// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:classmate/services/notification%20services/models.dart';

class LocalNotification {
  static void scheduleNotifications(ClassNotificationList classList) async {
    var days = classList.notificationOnClasses;
    // print(" local ${days.length} on now weekday ${DateTime.now().weekday}");
    for (int i = 0; i < days.length; i++) {
      if (days[i].num != null && days[i].startTime != null) {
        int weekday = days[i].num;

        // Schedule notification 5 minutes before the start time
        Duration duration = const Duration(minutes: 5);
        DateTime newStartTime = days[i].startTime.subtract(duration);
        print('current time ${DateTime.now()}');

        //
        print(
            "create-$i-${days[i].startTime.hour}:${days[i].startTime.minute}:${newStartTime.minute} fore${getWeekday(weekday)} $weekday/${DateTime.now().weekday} ${days[i].startTime}");

        // Create notification
        final isCreated = await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i + weekday * Random().nextInt(10),
            channelKey: 'basic_channel',
            title: '${days[i].classInfo.name} class is going to start...😊',
            body:
                'Room: ${days[i].classInfo.name} \nInstructor: ${days[i].classInfo.instructorName} \nPeriod: ${days[i].start}-${days[i].end}',
            notificationLayout: NotificationLayout.Default,
            // payload: {'data': 'notification_'},
            wakeUpScreen: true,
            displayOnBackground: true,
          ),
          schedule: NotificationCalendar(
            weekday: getWeekday(weekday),
            hour: newStartTime.hour,
            minute: newStartTime.minute.toInt(),
            // minute: after30s.minute,
            // second: after30s.second,
            allowWhileIdle: true,
            repeats: true,
            timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'dismiss',
              label: 'Dismiss',
              isDangerousOption: true,
            ),
          ],
        );
        print("isCreated : $isCreated");
      }
    }
  }
}

int getWeekday(int weekday) {
  if (weekday == 0) {
    return 0;
  } else {
    return weekday;
  }
}
