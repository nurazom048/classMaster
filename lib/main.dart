// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/loginSection/login_sceen.dart';
import 'package:table/old/rutinprovider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Rutinprovider()),
          ChangeNotifierProvider(create: (context) => PriodeDateProvider()),
          ChangeNotifierProvider(create: (context) => MyRutinProvider()),
          ChangeNotifierProvider(create: (context) => TopPriodeProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: LoginScreen(),
        ));
  }
}
