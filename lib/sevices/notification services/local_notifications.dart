import 'package:awesome_notifications/awesome_notifications.dart';
import '../../models/class_details_model.dart';

class LocalNotification {
  static void scheduleNotifications(List<Day?> days) async {
    print("Ontap local on");
    for (int i = 0; i < days.length - 1; i++) {
      //

      if (days[i]?.num == null || days[i]?.startTime == null) {
        print("Not create $i");
      } else {
        if (i > days.length || i == days.length) {}
        print(" create $i");
        int weekday = days[i]!.num;
        print(weekday);

        // Calculate the next occurrence of the selected weekday
        DateTime now = DateTime.now();
        DateTime nextDate = DateTime.utc(
          now.year,
          now.month,
          now.day,
          days[i]?.startTime.hour ?? 0,
          days[i]?.startTime.minute ?? 0,
        ).add(Duration(days: ((weekday - now.weekday + 7) % 7)));

        // await AwesomeNotifications().cancelAllSchedules();

        // for (int i = 0; i < days.length; i++) {
        //   if (days[i]?.num == null || days[i]?.startTime == null) {
        //     print("Not create");
        //   } else {
        // Schedule the notification
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'basic_channel',
            title: '${days[i]?.classId.name} class is going to start...😊',
            body:
                'Room: ${days[i]?.room} \nInstructor: ${days[i]?.classId.instuctorName} \nPeriod: ${days[i]?.start}',
            notificationLayout: NotificationLayout.Default,
            payload: {'data': 'notification_'},
          ),
          schedule: NotificationCalendar(
            // weekday: weekday,
            hour: nextDate.hour,
            minute: nextDate.minute,
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
