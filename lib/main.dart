// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/Alart.dart';

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
      // home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    var errorMessage = "message";
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final saveRutin = ref.watch(save_rutins_provider(1));
          return Column(
            children: [
              saveRutin.when(
                  data: (d) => Text(d.toString()),
                  loading: () => const Text("lodinh"),
                  error: (error, stackTrace) {
                    Future.delayed(Duration.zero, () {
                      Alart.showSnackBar(context, error.toString());
                    });
                    return const SizedBox.shrink();
                  })
            ],
          );
        },
      ),
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
