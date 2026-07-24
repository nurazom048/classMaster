// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../../models.dart';

// Conditional import to safely call JS on Web without breaking compilation on Android/iOS
import 'web_notification_stub.dart'
    if (dart.library.js) 'web_notification_js.dart';

class WebNotificationHelper {
  static final Set<String> _scheduledKeys = {};

  /// Request notification permission on web browser
  static void requestWebPermission() {
    if (!kIsWeb) return;
    try {
      callJsScheduleNotification("", "", -1);
    } catch (e) {
      print("Error requesting web notification permission: $e");
    }
  }

  /// Checks if web notification permission is already granted
  static bool isPermissionGranted() {
    if (!kIsWeb) return false;
    try {
      return checkWebNotificationPermission();
    } catch (e) {
      return false;
    }
  }

  /// Base method to schedule offline notification on Web browser
  static void scheduleNotification({
    required String title,
    required String body,
    required DateTime notifyTime,
    String? uniqueKey,
  }) {
    if (!kIsWeb) return;

    if (uniqueKey != null && _scheduledKeys.contains(uniqueKey)) {
      return;
    }

    if (notifyTime.isBefore(DateTime.now())) {
      print("Notification time has already passed for: $title ($notifyTime)");
      return;
    }

    try {
      if (uniqueKey != null) {
        _scheduledKeys.add(uniqueKey);
      }
      callJsScheduleNotification(
        title,
        body,
        notifyTime.millisecondsSinceEpoch,
      );
      print("Web notification scheduled for $title at $notifyTime");
    } catch (e) {
      print("Error in WebNotificationHelper.scheduleNotification: $e");
    }
  }

  static int _getWeekdayNumber(String dayStr) {
    switch (dayStr.toLowerCase().trim()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        return DateTime.friday;
    }
  }

  /// Schedule notifications for recurring weekly classes (up to 4 upcoming weeks)
  static void scheduleFromNotificationResponse(
    ClassNotificationResponse data, {
    Duration offset = const Duration(minutes: 15),
    int weeksToSchedule = 4,
  }) {
    if (!kIsWeb) return;

    final days = data.allClassForNotification;
    final now = DateTime.now();

    for (int i = 0; i < days.length; i++) {
      final item = days[i];

      // 🛑 SKIP IF NOTIFICATION IS TURNED OFF FOR THIS ROUTINE/CLASS!
      if (item.notificationOn == false) {
        print(
          "❌ [Web Notification Skipped] Routine ${item.routineId} - Class ${item.classDetails.name} (Notification is OFF)",
        );
        continue;
      }

      int targetWeekday = _getWeekdayNumber(item.day);
      int daysUntil = (targetWeekday - now.weekday) % 7;
      if (daysUntil < 0) daysUntil += 7;

      int classHour = item.startTime.hour;
      int classMinute = item.startTime.minute;

      // Find the first upcoming class date
      DateTime firstClassDate = DateTime(
        now.year,
        now.month,
        now.day + daysUntil,
        classHour,
        classMinute,
      );

      // If notify time for this firstClassDate has already passed today, start from next week
      if (firstClassDate.subtract(offset).isBefore(now)) {
        firstClassDate = firstClassDate.add(const Duration(days: 7));
      }

      // Schedule for upcoming weeks (up to 4 weeks in advance)
      for (int week = 0; week < weeksToSchedule; week++) {
        final DateTime targetClassDate = firstClassDate.add(
          Duration(days: week * 7),
        );
        final DateTime notifyTime = targetClassDate.subtract(offset);

        // JS setTimeout max limit is 2,147,483,647 ms (~24.8 days)
        final int delayMs =
            notifyTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
        if (delayMs <= 0 || delayMs > 2147483647) {
          continue;
        }

        final String title = "${item.classDetails.name} Alert! 🔔";
        final String body =
            "${item.classDetails.name} starts in ${offset.inMinutes} mins at Room ${item.room}. Instructor: ${item.classDetails.instructorName}";

        final String uniqueKey =
            "${item.id}_${item.classId}_${notifyTime.millisecondsSinceEpoch}";

        if (_scheduledKeys.contains(uniqueKey)) {
          continue;
        }

        print(
          "✅ [NOTIFICATION CREATED] 📅 Day: ${item.day} | 🕒 StartTime: $targetClassDate | ⏰ NotifyAt: $notifyTime | 🏷️ Title: '$title' | 📢 Body: '$body' | 🕒 CreatedAt: ${DateTime.now()}",
        );

        scheduleNotification(
          title: title,
          body: body,
          notifyTime: notifyTime,
          uniqueKey: uniqueKey,
        );
      }
    }
  }

  /// Schedule notification from raw API response Map
  static void scheduleClassNotificationForWeb(
    Map<String, dynamic> apiResponse,
  ) {
    if (!kIsWeb) return;

    try {
      String className = apiResponse['class_name'] ?? 'Unknown Class';
      String roomNumber = apiResponse['room_number'] ?? 'TBA';

      DateTime rawTime = DateTime.parse(apiResponse['start_time']);
      DateTime now = DateTime.now();
      DateTime startTime = DateTime(
        now.year,
        now.month,
        now.day,
        rawTime.hour,
        rawTime.minute,
      );
      DateTime notifyTime = startTime.subtract(const Duration(minutes: 15));

      String title = "$className Alert! 🔔";
      String body = "$className starts in 15 mins at Room $roomNumber.";

      scheduleNotification(title: title, body: body, notifyTime: notifyTime);
    } catch (e) {
      print("Error scheduling web notification from map: $e");
    }
  }
}
