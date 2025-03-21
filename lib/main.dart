// Core Flutter and Dart imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// State management and routing
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/route/app_router.dart';

// Firebase-related imports
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'services/firebase/firebase_options.dart';

// Third-party utilities
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

// App-specific imports
import 'core/constant/constant.dart';
import 'services/notification services/awn_package.dart'; // Fixed typo in path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase initialize
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
  // remove # path
  setPathUrlStrategy();
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('signUpInfo'); // Open a box

  //* sentry crash report
  await SentryFlutter.init((options) {
    options.dsn =
        'https://17fd9ac810472652be659f50fd826efb@o4506556979150848.ingest.sentry.io/4506556985311232';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
  }, appRunner: () => runApp(const ProviderScope(child: MyApp())));
}
//

//
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: Const.appName,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFEFF6FF),
          primarySwatch: Colors.blue,
        ),
        //home: const AboutScreen(),

        routeInformationParser: AppRouters().router.routeInformationParser,
        routerDelegate: AppRouters().router.routerDelegate,
      ),
    );
  }
}
