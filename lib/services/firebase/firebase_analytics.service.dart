import 'package:firebase_analytics/firebase_analytics.dart';

import '../../ui/auth_Section/auth_controller/auth_controller.dart';

class FirebaseAnalyticsServices {
  // Log Events
  static void logEvent(
      {required String name, required Map<String, Object?>? parameters}) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  //
  static logHome() async {
    String? username = await AuthController.getUsername();

    await FirebaseAnalytics.instance.logEvent(
      name: 'Home Screen',
      parameters: {'username': '$username'},
    );
  }
}
