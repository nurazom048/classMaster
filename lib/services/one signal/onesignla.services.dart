import 'package:app_settings/app_settings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalServices {
// initialize

  static void initialize() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId('db13122e-448d-4418-9df0-b83989eef9ab');

    // final status = await OneSignal.shared.getDeviceState();
    // final String? osUserID = status?.userId;
    // // ignore: avoid_print
    // print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
    // // ignore: avoid_print
    // print("osUserID : $osUserID");
  }

// permission
  static void oneSignalPermission() {
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      if (value == true) {
        // ignore: avoid_print
        print('accept Permission $value');
      } else {
        AppSettings.openNotificationSettings();
      }
    });
  }
}
