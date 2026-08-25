// Core Flutter and Dart imports
import 'package:classmate/features/account_fetures/presentation/screens/edit_account.dart';
import 'package:classmate/services/notification_services/awn_package.dart';
import 'package:classmate/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// State management and routing
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/route/app_router.dart';

// Firebase-related imports
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'services/firebase/firebase_options.dart';

// Third-party utilities
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

// App-specific imports
import 'core/constant/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //crashlytics
  if (!kIsWeb) {
    // Initialize Crashlytics for non-Web platforms
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    // ignore: avoid_print
    print("Crashlytics is disabled on Web.");
  }
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
  }, appRunner: () => runApp(ProviderScope(child: MyApp())));
}
//

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  // Create only ONE GoRouter instance
  final router = AppRouters().router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return themeAsync.when(
      loading: () {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (error, stackTrace) {
        return MaterialApp(
          home: Scaffold(body: Center(child: Text('Theme load error: $error'))),
        );
      },
      data: (themeMode) {
        return GetMaterialApp.router(
          key: ValueKey(themeMode.hashCode),
          debugShowCheckedModeBanner: false,
          title: Const.appName,
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: themeNotifier.flutterThemeMode,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
          routerDelegate: router.routerDelegate,
        );
      },
    );
  }
}

// flutter run -d edge --release --web-port 5000
// flutter run -d chrome --release --web-port 5000

/*
================================================================================
Antigravity Multi-Device Workflow System Notes:
================================================================================
আপনার Flutter প্রজেক্টটি সার্ভারে /DATA/AppData/classmaster-এ সফলভাবে ক্লোন করা হয়েছে!

এখন থেকে:
1. আমি (Antigravity) আপনার Flutter Frontend (/DATA/AppData/classmaster) এবং Node.js Backend (/DATA/AppData/classmaster-api) — দুটো প্রজেক্টের যেকোনো ফাইল পড়তে, নতুন কোড লিখতে বা মডিফাই করতে পারব।
2. আমি কোড পরিবর্তন করে দিলে আপনি আপনার ল্যাপটপে git pull দিলেই আপডেট পেয়ে যাবেন এবং ল্যাপটপে সহজে টেস্ট করতে পারবেন।
3. আপনি আপনার যেকোনো ফিচার ডেভেলপমেন্ট, বাগ ফিক্স বা কোড চেঞ্জের প্রয়োজন হলে আমাকে জানান!
================================================================================
*/

