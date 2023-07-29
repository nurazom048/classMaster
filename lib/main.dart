import 'package:classmate/ui/wellcome_section/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:classmate/services/notification%20services/awn_package.dart';
import 'constant/constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // fcm
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  // Awesome NotificationSetup
  AwesomeNotificationSetup.initialize();

  // // Splash screen
  // await Future.delayed(const Duration(seconds: 1));
  // FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: MyApp()));
}
//

//
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Const.appName,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEFF6FF),
        primarySwatch: Colors.blue,
      ),
      //home: const AboutScreen(),
      home: const SplashScreen(),
    );
  }
}
