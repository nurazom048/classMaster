// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';

class DaysContaner extends StatelessWidget {
  int indexofdate;
  DaysContaner({super.key, required this.indexofdate});

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    //.. to chack is the is today ...//
    String isToday(String day) {
      DateTime now = DateTime.now();
      String today = sevendays[now.weekday];
      return day == today ? "today" : sevendays[indexofdate];
    }

    return Container(
      decoration: BoxDecoration(
          color: getColor(indexofdate),
          border:
              const Border(right: BorderSide(color: Colors.black, width: 1))),
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isToday(sevendays[indexofdate])), //.. show the day name
          IconButton(
              onPressed: (() => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>
                          AddClass(dayname: isToday(sevendays[indexofdate]))))),
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }

  ///.... for changling color....//
  Color getColor(int indexofdate) {
    return indexofdate % 2 == 0
        ? const Color.fromRGBO(207, 213, 234, 1)
        : Colors.black12;
  }
}
