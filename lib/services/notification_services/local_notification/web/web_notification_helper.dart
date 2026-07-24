// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../../models.dart';

// Conditional import to safely call JS on Web without breaking compilation on Android/iOS
import 'web_notification_stub.dart'
    if (dart.library.js) 'web_notification_js.dart';

class WebNotificationHelper {
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
  }) {
    if (!kIsWeb) return;

    if (notifyTime.isBefore(DateTime.now())) {
      print("Notification time has already passed for: $title");
      return;
    }

    try {
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

  /// Schedule notifications using the common ClassNotificationResponse model
  static void scheduleFromNotificationResponse(
    ClassNotificationResponse data, {
    Duration offset = const Duration(minutes: 15),
  }) {
    if (!kIsWeb) return;

    final days = data.allClassForNotification;
    print("🔔 [WebNotificationHelper] Scheduling ${days.length} notifications at ${DateTime.now()}");

    for (int i = 0; i < days.length; i++) {
      final item = days[i];

      // 🛑 SKIP IF NOTIFICATION IS TURNED OFF FOR THIS ROUTINE/CLASS!
      if (item.notificationOn == false) {
        print("❌ [Web Notification Skipped] Routine ${item.routineId} - Class ${item.classDetails.name} (Notification is OFF)");
        continue;
      }

      final DateTime notifyTime = item.startTime.subtract(offset);
      final String title = "${item.classDetails.name} Alert! 🔔";
      final String body =
          "${item.classDetails.name} starts in ${offset.inMinutes} mins at Room ${item.room}. Instructor: ${item.classDetails.instructorName}";

      print(
        "✅ [NOTIFICATION CREATED] 📅 Day: ${item.day} | 🕒 StartTime: ${item.startTime} | ⏰ NotifyAt: $notifyTime | 🏷️ Title: '$title' | 📢 Body: '$body' | 🕒 CreatedAt: ${DateTime.now()}",
      );

      scheduleNotification(
        title: title,
        body: body,
        notifyTime: notifyTime,
      );
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

      DateTime startTime = DateTime.parse(apiResponse['start_time']);
      DateTime notifyTime = startTime.subtract(const Duration(minutes: 15));

      String title = "Upcoming Class Alert! 🔔";
      String body = "$className is starting in 15 mins at Room $roomNumber.";

      scheduleNotification(
        title: title,
        body: body,
        notifyTime: notifyTime,
      );
    } catch (e) {
      print("Error scheduling web notification from map: $e");
    }
  }
}
