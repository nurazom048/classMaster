import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllRutins extends StatelessWidget {
  AllRutins({super.key});

  List<Map<String, dynamic>> mypriodelist = [
    {
      "start_time": DateTime(2022, 09, 03, 8, 59),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
    {
      "start_time": DateTime(2022, 09, 03, 8, 40),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 200,
            width: 300,
            color: Colors.black12,
            child: Column(
              children: [
                Priode(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Wrap Priode() {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
        3,
        (index) => Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(68, 114, 196, 40),
              border:
                  Border(right: BorderSide(color: Colors.black45, width: 1))),
          child: Column(
            children: [
              Text(index.toString()),
              const Divider(color: Colors.black87, height: 1, thickness: .5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(formatTime(mypriodelist[index]["start_time"])),
                  Text(formatTime(mypriodelist[index]["end_time"])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
