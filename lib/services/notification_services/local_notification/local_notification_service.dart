import 'package:flutter/foundation.dart';
import '../models/notification_models.dart';
import 'web/web_notification_helper.dart';

import 'android/android_notification_stub.dart'
    if (dart.library.io) 'android/android_notification_helper.dart';

class LocalNotification {
  static void scheduleNotifications(ClassNotificationResponse data) async {
    // ignore: avoid_print
    print("🔔 [LocalNotification] Received ${data.allClassForNotification.length} active classes to schedule at ${DateTime.now()}");

    // 🌐 Web Environment -> Handled by WebNotificationHelper
    if (kIsWeb) {
      WebNotificationHelper.scheduleFromNotificationResponse(data);
      return;
    }

    // 📱 Android / Mobile Environment -> Handled by AndroidNotificationHelper
    var days = data.allClassForNotification;
    for (int i = 0; i < days.length; i++) {
      final item = days[i];

      // 🛑 SKIP IF NOTIFICATION IS TURNED OFF FOR THIS ROUTINE/CLASS!
      if (item.notificationOn == false) {
        // ignore: avoid_print
        print("❌ [Notification Skipped] Routine ${item.routineId} - Class ${item.classDetails.name} (Notification is OFF)");
        continue;
      }

      int weekday = getWeekdayInt(item.day);
      // ignore: avoid_print
      print(
        "✅ [NOTIFICATION CREATED] 📅 Day: ${item.day} | 🕒 StartTime: ${item.startTime} | 🏷️ Name: ${item.classDetails.name} | 📍 Room: ${item.room} | 🕒 CreatedAt: ${DateTime.now()}",
      );
      AndroidNotificationHelper.scheduleNotification(item, i, getWeekday(weekday));
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
