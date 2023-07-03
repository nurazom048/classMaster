//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:table/ui/auth_Section/auth_ui/logIn_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> handerBgMessge(RemoteMessage message) async {
//   await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//     id: 3999,
//     channelKey: 'basic_channel',
//     body: message.notification?.body ?? 'body',
//     title: message.notification?.title ?? 'tittle',
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //firebase messagein
  // final messageIns = FirebaseMessaging.instance;

  // await messageIns.requestPermission(
  //     alert: true, announcement: true, badge: true, sound: true);
  // final fcmToken = await messageIns.getToken();
  // FirebaseMessaging.onBackgroundMessage(handerBgMessge);
  // print('fcmToken  $fcmToken');

  // creash latics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
// Firebase anlytices
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEFF6FF),
        primarySwatch: Colors.blue,
      ),
      home: const LogingScreen(),
    );
  }
}
