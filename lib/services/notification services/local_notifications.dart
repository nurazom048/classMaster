// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:classmate/services/notification%20services/models.dart';

class LocalNotification {
  static void scheduleNotifications(ClassNotificationResponse data) async {
    var days = data.allClassForNotification;
    // print(" local ${days.length} on now weekday ${DateTime.now().weekday}");
    for (int i = 0; i < days.length; i++) {
      if (days[i].day != null && days[i].startTime != null) {
        int weekday = getWeekdayInt(days[i].day);

        // Schedule notification 5 minutes before the start time
        Duration duration = const Duration(minutes: 5);
        DateTime newStartTime = days[i].startTime.subtract(duration);
        print(
          'current time ${DateTime.now()} : weekday ${DateTime.now().weekday} ',
        );

        //
        print(
          "create-$i-${days[i].startTime.hour}:${days[i].startTime.minute}:${newStartTime.minute} modified ${getWeekday(weekday)} Mongo$weekday/today${DateTime.now().weekday} ${days[i].startTime}",
        );

        // Create notification
        try {
          // final isCreated = await AwesomeNotifications().createNotification(
          //   content: NotificationContent(
          //     id: i,
          //     channelKey: 'basic_channel',
          //     title:
          //         '${days[i].classDetails.name} class is going to start...😊',
          //     body:
          //         'Room: ${days[i].classDetails.name} \nInstructor: ${days[i].classDetails.instructorName} \nPeriod: ${days[i].startTime}-${days[i].endTime}',
          //     notificationLayout: NotificationLayout.Default,
          //     // payload: {'data': 'notification_'},
          //     wakeUpScreen: true,
          //     displayOnBackground: true,
          //   ),
          //   schedule: NotificationCalendar(
          //     weekday: getWeekday(weekday),
          //     hour: newStartTime.hour,
          //     minute: newStartTime.minute.toInt(),
          //     // minute: after30s.minute,
          //     // second: after30s.second,
          //     allowWhileIdle: true,
          //     repeats: true,
          //     timeZone:
          //         await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          //   ),
          //   actionButtons: [
          //     NotificationActionButton(
          //       key: 'dismiss',
          //       label: 'Dismiss',
          //       isDangerousOption: true,
          //     ),
          //   ],
          // );
          // print("isCreated : $isCreated");
        } catch (e) {
          print(
            'Error create local notification :${getWeekday(weekday)} /$weekday : $e',
          );
        }
      }
    }
  }
}

int getWeekday(int weekday) {
  if (weekday == 0) {
    return 7;
  } else {
    return weekday;
  }
}

int getWeekdayInt(String shortDay) {
  const List<String> days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

  int dayIndex = days.indexOf(shortDay.toLowerCase());

  if (dayIndex == -1) {
    throw ArgumentError("Invalid day string: $shortDay");
  }

  return dayIndex + 1;
}
