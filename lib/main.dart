import 'package:flutter/material.dart';
import 'package:table/dataTable.dart';
import 'package:table/freash.dart';
import 'package:table/moidels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWidget(),
      // home: DataTAble(),
    );
  }
}

class Tabile3 extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  Tabile3({super.key});

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
    ];
    //List set = ["Set", "mn", "mn", "usr", "4"];

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopContaner(
                    priode: 'Priode', startTime: "sevendays", endtime: "Time"),
                Wrap(
                  //direction: Axis.horizontal,
                  children: List.generate(
                    sevendays.length,
                    (index) => TopContaner(
                      priode: "${index + 1}",
                      startTime: "8:00",
                      endtime: "8:45",
                    ),
                  ),
                ),
//////// 2nd
              ],
            ),
          ],
        ),
      ),
    );
  }

  pridodeincolumn(
      {required classinfo, required List<Classmodel> comperpriodmodel}) {}
}

class SevenDays extends StatelessWidget {
  const SevenDays({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
    ];
    return Wrap(
      direction: Axis.vertical,
      children: List.generate(
        sevendays.length,
        (index) => Container(
            decoration: BoxDecoration(
                color: index % 2 == 0
                    ? const Color.fromRGBO(68, 114, 196, 161)
                    : const Color.fromRGBO(191, 191, 191, 161),
                border: const Border(
                    right: BorderSide(color: Colors.black45, width: 1))),
            height: 100,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sevendays[index]),
              ],
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class ClassContaner extends StatelessWidget {
  Color? color;
  String teachername;
  int subjectcode, roomnum;
  // ignore: prefer_typing_uninitialized_variables
  var onTap, bordercolor;

  ClassContaner({
    Key? key,
    required this.color,
    required this.teachername,
    required this.roomnum,
    required this.subjectcode,
    required this.onTap,
    this.bordercolor = Colors.black45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: color,
              border: Border(right: BorderSide(color: bordercolor, width: 1))),
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(teachername),
              Text(subjectcode.toString()),
              Text(roomnum.toString()),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class TopContaner extends StatelessWidget {
  String priode, startTime, endtime;
  TopContaner({
    Key? key,
    required this.priode,
    required this.startTime,
    required this.endtime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 100,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
          color: const Color.fromRGBO(68, 114, 196, 30),
          border:
              const Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(priode),
          const Divider(color: Colors.black87, height: 18, thickness: .5),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("$startTime \n$endtime"),
          ),
        ],
      ),
    );
  }
}
