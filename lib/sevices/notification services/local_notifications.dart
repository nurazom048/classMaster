// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:table/sevices/notification%20services/models.dart';

class LocalNotification {
  static void scheduleNotifications(ClassNotificationList classList) async {
    var days = classList.notificationOnClasses;
    print(
        "Ontap local ${days.length} on now weekday ${DateTime.now().weekday}");
    for (int i = 0; i < days.length; i++) {
      if (days[i].num != null && days[i].startTime != null) {
        int weekday = days[i].num;
        print(
            "create $i sH${days[i].startTime.hour} ${days[i].startTime}    h:${makeTime24h(days[i].startTime)} M:${days[i].startTime.minute} $weekday ${days[i].num} ${days[i].startTime}");

        // Schedule notification 5 minutes before the start time
        Duration duration = const Duration(minutes: 5);
        DateTime newStartTime = days[i].startTime.subtract(duration);

        // Create notification
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'basic_channel',
            title: '${days[i].classInfo.name} class is going to start...😊',
            body:
                'Room: ${days[i].room} \nInstructor: ${days[i].classInfo.instructorName} \nPeriod: ${days[i].start}-${days[i].end}',
            notificationLayout: NotificationLayout.Default,
            payload: {'data': 'notification_'},
          ),
          schedule: NotificationCalendar(
            //  weekday: weekday,
            hour: newStartTime.hour,
            minute: newStartTime.minute.toInt(),
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

// class LocalNotification {
//   static void scheduleNotifications(ClassNotificationList classList) async {
//     var days = classList.notificationOnClasses;
//     print("Ontap local on now weekday ${DateTime.now().weekday} ");
//     for (int i = 0; i < days.length; i++) {
//       //

//       if (days[i].num == null || days[i].startTime == null) {
//       } else {
//         int weekday = days[i].num ?? 0;
//         print("create $i   $weekday ${days[i].num} ${days[i].startTime}");

//         // before 5 mimute send notification
//         Duration duration = const Duration(minutes: 5);
//         DateTime newStartTime = days[i]!.startTime.subtract(duration);

// // create notification
//         await AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: i,
//             channelKey: 'basic_channel',
//             title: '${days[i].classInfo.name} class is going to start...😊',
//             body:
//                 'Room: ${days[i].room} \nInstructor: ${days[i].classInfo.instructorName} \nPeriod: ${days[i]?.start}-${days[i]?.start} ',
//             notificationLayout: NotificationLayout.Default,
//             payload: {'data': 'notification_'},
//           ),
//           schedule: NotificationCalendar(
//             //weekday: weekday,
//             hour: newStartTime.hour,
//             minute: newStartTime.minute,
//             allowWhileIdle: true,
//           ),
//           actionButtons: [
//             NotificationActionButton(
//               key: 'dismiss',
//               label: 'Dismiss',
//             ),
//           ],
//         );
//       }
//     }
//   }
// }

// class LocalNotification {
//   static void scheduleNotifications(List<Day?> days) async {
// //     print("Ontap local on now weekday ${DateTime.now().weekday} ");
// //     for (int i = 0; i < days.length; i++) {
// //       //

// //       if (days[i]?.num == null || days[i]?.startTime == null) {
// //       } else {
// //         int weekday = days[i]?.num ?? 0;
// //         print("create $i   $weekday ${days[i]?.num} ${days[i]?.startTime}");

// //         // before 5 mimute send notification
// //         Duration duration = const Duration(minutes: 5);
// //         DateTime newStartTime = days[i]!.startTime.subtract(duration);

// // // create notification
// //         await AwesomeNotifications().createNotification(
// //           content: NotificationContent(
// //             id: i,
// //             channelKey: 'basic_channel',
// //             title: '${days[i]?.classId.name} class is going to start...😊',
// //             body:
// //                 'Room: ${days[i]?.room} \nInstructor: ${days[i]?.classId.instuctorName} \nPeriod: ${days[i]?.start}-${days[i]?.start} ',
// //             notificationLayout: NotificationLayout.Default,
// //             payload: {'data': 'notification_'},
// //           ),
// //           schedule: NotificationCalendar(
// //             //weekday: weekday,
// //             hour: newStartTime.hour,
// //             minute: newStartTime.minute,
// //             allowWhileIdle: true,
// //           ),
// //           actionButtons: [
// //             NotificationActionButton(
// //               key: 'dismiss',
// //               label: 'Dismiss',
// //             ),
// //           ],
// //         );
// //       }
// //     }
//   }
// }
int makeTime24h(DateTime startTime) {
  int hours = startTime.hour;
  String amPm = startTime.hour < 12 ? 'AM' : 'PM';

  if (amPm == 'AM') {
    // Convert AM time to 24-hour format
    if (hours == 12) {
      hours = 0;
    }
  } else {
    // Convert PM time to 24-hour format
    if (hours != 12) {
      hours = hours + 12;
    }
  }

  return hours;
}
