// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';

class DaysContaner extends StatelessWidget {
  int indexofdate;

  bool? ismini;
  DaysContaner({super.key, this.ismini, required this.indexofdate});

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
      height: ismini == true ? 50 : 100,
      width: ismini == true ? 50 : 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text("${DateTime.now().weekday}"),
          // Text("${DateTime.now().day}"),
          Text(isToday(sevendays[indexofdate]),
              style: ismini == true
                  ? const TextStyle(fontSize: 10)
                  : const TextStyle()), //.. show the day name
          ismini == false
              ? IconButton(
                  onPressed: (() => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => AddClass(
                                rutinId: "",
                              )))),
                  icon: const Icon(Icons.add))
              : Container()
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
