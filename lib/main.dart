// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';
import 'ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      //home: MyWidget(),
    );
  }
}

class allRequestNotifier extends StateNotifier<bool> {
  allRequestNotifier(this.ref, this.rutinId) : super(false) {
    _init();
  }

  WidgetRef ref;
  String rutinId;

  void _init() {
    final statusUserProvider = chackStatusUser_provider(rutinId);
    final statusUser = ref.watch(statusUserProvider);

    state = statusUser.value?.isSave ?? false;
  }
}

class MySAve extends ConsumerWidget {
  const MySAve({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Text("data"),
          TextButton(
            onPressed: () {},
            child: Text("save"),
          ),
          TextButton(
            onPressed: () {},
            child: Text("UMsave"),
          )
        ],
      ),
    );
  }
}
