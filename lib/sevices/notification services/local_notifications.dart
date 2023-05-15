// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import '../../models/class_details_model.dart';

class LocalNotification {
  static void scheduleNotifications(List<Day?> days) async {
    print("Ontap local on now weekday ${DateTime.now().weekday} ");
    for (int i = 0; i < days.length; i++) {
      //

      if (days[i]?.num == null || days[i]?.startTime == null) {
      } else {
        int weekday = days[i]?.num ?? 0;
        print("create $i   $weekday ${days[i]?.num} ${days[i]?.startTime}");

        // before 5 mimute send notification
        Duration duration = const Duration(minutes: 5);
        DateTime newStartTime = days[i]!.startTime.subtract(duration);

// create notification
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'basic_channel',
            title: '${days[i]?.classId.name} class is going to start...😊',
            body:
                'Room: ${days[i]?.room} \nInstructor: ${days[i]?.classId.instuctorName} \nPeriod: ${days[i]?.start}-${days[i]?.start} ',
            notificationLayout: NotificationLayout.Default,
            payload: {'data': 'notification_'},
          ),
          schedule: NotificationCalendar(
            //weekday: weekday,
            hour: newStartTime.hour,
            minute: newStartTime.minute,
            allowWhileIdle: true,
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
