import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:table/services/notification%20services/awn_package.dart';
import 'package:table/ui/auth_Section/auth_ui/wellcome_screen.dart';
import 'firebase_options.dart';

import 'helper/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // crashlytics
  // // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  //fcm
  // Firebase analytics
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  // Awesome NotificationSetup
  AwesomeNotificationSetup.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
//

//
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    navigateBaseOnToken();
    super.initState();
  }

//
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
      //  home: const LoginScreen(),
      home: const WellComeScreen(),
    );
  }
}
