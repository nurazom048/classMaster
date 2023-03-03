// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/loginSection/login_sceen.dart';
import 'package:table/ui/server/homeRequest.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      //  home: MyWidget(),
    );
  }
}

class MyWidget extends ConsumerWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRutin = ref.watch(all_rutins_provider);
    return Scaffold(
      appBar: AppBar(),
      body: myRutin.when(
        data: (value) => Text("$value"),
        error: (err, stackTrace) => Text("error"),
        loading: () => Text("loading"),
      ),
    );
  }
}
