import 'package:firebase_analytics/firebase_analytics.dart';

import '../../local data/local_data.dart';

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
    String? username = await LocalData.getUsername();

    await FirebaseAnalytics.instance.logEvent(
      name: 'Home Screen',
      parameters: {'username': '$username'},
    );
  }
}
