import 'dart:js' as js;

/// Calls JS function scheduleOfflineWebNotification in web/index.html
void callJsScheduleNotification(String title, String body, int timestamp) {
  js.context.callMethod('scheduleOfflineWebNotification', [
    title,
    body,
    timestamp,
  ]);
}

/// Calls JS function isWebNotificationGranted in web/index.html
bool checkWebNotificationPermission() {
  try {
    final result = js.context.callMethod('isWebNotificationGranted');
    return result == true;
  } catch (e) {
    return false;
  }
}
