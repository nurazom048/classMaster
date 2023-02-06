import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/bottom_items/all_rutins.dart';
import 'package:table/ui/bottom_items/bottm_nev_bar.dart';
import 'package:table/ui/loginSection/login_sceen.dart';
import 'package:table/ui/rutin_screen.dart';
import 'package:table/old/rutinprovider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Rutinprovider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PriodeDateProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MyRutinProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TopPriodeProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // ignore: prefer_const_constructors
          home: BottomNewBar(),
        ));
  }
}

// ignore: must_be_immutable
class TopContaner extends StatelessWidget {
  String priode, startTime, endtime;
  // ignore: prefer_typing_uninitialized_variables
  var onTap;
  IconData? iconn;
  TopContaner({
    Key? key,
    required this.priode,
    required this.startTime,
    required this.endtime,
    this.onTap,
    this.iconn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
          color: const Color.fromRGBO(68, 114, 196, 40),
          border:
              const Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Text(priode),
            const Divider(color: Colors.black87, height: 10, thickness: .5),
            Text("$startTime \n$endtime"),
            InkWell(onTap: onTap, child: Icon(iconn)),
          ],
        ),
      ),
    );
  }
}
