// ignore_for_file: avoid_print

import '../../models.dart';

class AndroidNotificationHelper {
  static void initialize() {
    // Android local notification setup
  }

  static void scheduleNotification(
      WeekdayForNotificationModel item, int index, int weekday) {
    print("Android notification scheduled for ${item.classDetails.name}");
  }
}
