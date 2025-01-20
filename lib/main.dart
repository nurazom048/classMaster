import 'package:classmate/route/app_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/services/notification%20services/awn_package.dart';
import 'package:url_strategy/url_strategy.dart';
import 'core/constant/constant.dart';
import 'services/firebase/firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  // }
  // Awesome NotificationSetup
  AwesomeNotificationSetup.initialize();
  // remove # path
  setPathUrlStrategy();

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
