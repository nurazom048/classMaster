// lib/main.dart
// Core Flutter and Dart imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// State management and routing
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart'; // GetX is used for routing here it seems
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
import 'core/constant/constant.dart'; // Core constants like app name.
import 'services/notification services/awn_package.dart'; // Notification service setup.
import 'theme/app_theme.dart'; // Main application theme handler (ThemeNotifier, providers).
import 'theme/light_theme.dart'; // Specific ThemeData for the light mode.
import 'theme/dark_theme.dart'; // Specific ThemeData for the dark mode.

void main() async {
  // All initializations EXCEPT WidgetsFlutterBinding.ensureInitialized() happen here,
  // as they might be needed before Sentry's zone or have their own requirements.

  //firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //crashlytics
  if (!kIsWeb) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    print("Crashlytics is disabled on Web.");
  }
  // fcm
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
  // Awesome NotificationSetup
  AwesomeNotificationSetup.initialize();
  // remove # path
  setPathUrlStrategy();
  // Initialize Hive for local data storage.
  await Hive.initFlutter(); // Initialize Hive with the Flutter-specific directory.
  await Hive.openBox('signUpInfo'); // Open existing box for sign-up information.
  await Hive.openBox('settings'); // Open box for storing app settings, including theme preference.

  //* Sentry crash reporting setup.
  await SentryFlutter.init((options) {
    options.dsn =
        'https://17fd9ac810472652be659f50fd826efb@o4506556979150848.ingest.sentry.io/4506556985311232';
    options.tracesSampleRate = 1.0; // Capture 100% of transactions for performance monitoring.
  },
  appRunner: () {
    // Ensure that Flutter widgets are initialized *within the Sentry-managed zone*,
    // right before running the app. This helps prevent Zone mismatch errors.
    WidgetsFlutterBinding.ensureInitialized();
    // Wrap the app launch in ProviderScope for Riverpod state management.
    runApp(const ProviderScope(child: MyApp()));
  });
}

// MyApp is a ConsumerWidget to enable listening to Riverpod providers (like themeNotifierProvider).
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // WidgetRef ref is provided by ConsumerWidget, used to interact with providers.
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the themeNotifierProvider to get the current ThemeNotifier instance.
    // This will cause MyApp to rebuild when the theme changes.
    final themeNotifier = ref.watch(themeNotifierProvider);

    // GetMaterialApp is part of the GetX package.
    // It seems to be wrapping MaterialApp.router here.
    return GetMaterialApp(
      // The primary theme-related properties (theme, darkTheme, themeMode) are applied
      // to the MaterialApp.router instance, which is the standard Flutter way.
      home: MaterialApp.router(
        debugShowCheckedModeBanner: false, // Hides the debug banner.
        title: Const.appName, // Application title.

        // Apply theme settings from ThemeNotifier to MaterialApp.router.
        theme: themeNotifier.lightThemeData, // Provide the light theme data.
        darkTheme: themeNotifier.darkThemeData, // Provide the dark theme data.
        themeMode: themeNotifier.flutterThemeMode, // Set the theme mode (light, dark, or system).

        // Router configuration from app_router.dart.
        routeInformationParser: AppRouters().router.routeInformationParser,
        routerDelegate: AppRouters().router.routerDelegate,
      ),
    );
  }
}
