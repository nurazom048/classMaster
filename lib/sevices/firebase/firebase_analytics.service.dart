import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsServices {
  // Log Events
  static void logEvent(
      {required String name, required Map<String, Object?>? parameters}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
