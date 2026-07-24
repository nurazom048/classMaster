import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/export_core.dart';
import '../local_notification/web/web_notification_helper.dart';

import '../local_notification/android/android_notification_stub.dart'
    if (dart.library.io) '../local_notification/android/android_notification_helper.dart';

class AwesomeNotificationSetup {
  static void initialize() async {
    if (kIsWeb) return;
    AndroidNotificationHelper.initialize();
  }

  static void takePermission(BuildContext context) {
    // 🛑 If permission is already granted, do NOT show the dialog again!
    if (kIsWeb && WebNotificationHelper.isPermissionGranted()) {
      // ignore: avoid_print
      print("Notification permission is already granted.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notifications are already enabled! 🔔"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.teal,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(Icons.notifications_active, color: Colors.teal),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Allow Class Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'ClassMaster would like to send you notifications before your class starts so you never miss a lecture.',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Don\'t Allow',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (kIsWeb) {
                WebNotificationHelper.requestWebPermission();
              }
            },
            child: const Text(
              'Allow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
