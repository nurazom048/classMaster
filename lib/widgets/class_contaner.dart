// ignore_for_file: must_be_immutable, camel_case_types, avoid_print

import 'package:flutter/material.dart';

class ClassContainer extends StatelessWidget {
  String instractorname, roomnum, subCode, classname;
  String? has_class;
  num start, end, previous_end;
  var startTime, endTime;
  var weakday;
  dynamic onTap, onLongPress;
  dynamic weakdayIndex;

  ClassContainer({
    Key? key,
    required this.instractorname,
    required this.roomnum,
    required this.subCode,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
    this.has_class,
    required this.weakday,
    required this.classname,
    required this.previous_end,

    //
    this.onTap,
    this.onLongPress,
    required this.weakdayIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse("2023-01-01T22:11:00.000+00:00");

    //  var date = DateTime.parse(startTime);
    print(dateTime.hour);

//... foe Contaner with...//

    return Row(
      children: [
        crossContainer(start, previous_end),
        InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: getColor(weakdayIndex)),
            height: 100,
            width: contnerWidth(start, end),
            child: Container(
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.black, width: 1))),
              child: Column(
                children: [
                  checkIfRunning(startTime, endTime, weakday),
                  const Spacer(),
                  /////
                  Column(
                    children: [
                      Text(instractorname),
                      Text(subCode),
                      Text(roomnum),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///.... for changling color....//
  Color getColor(int indexofdate) {
    return indexofdate % 2 == 0
        ? const Color.fromRGBO(207, 213, 234, 1)
        : Colors.black12;
  }

  Widget checkIfRunning(DateTime startTime, DateTime endTime, weakday) {
    int currentHour = DateTime.now().hour;
    int currentMinute = DateTime.now().minute;

    int currentWek = DateTime.now().weekday;
    int currentWeekday = currentWek != 7 ? currentWek + 1 : 7;

    int startHour = startTime.hour;
    int startMinute = startTime.minute;

    int endHour = endTime.hour;
    int endMinute = endTime.minute;

    if (currentHour >= startHour &&
        currentMinute >= startMinute &&
        currentHour >= endHour &&
        currentMinute >= endMinute &&
        currentWeekday == weakday) {
      return Row(
        children: const [
          SizedBox(width: 5),
          CircleAvatar(backgroundColor: Colors.red, radius: 4),
          Text(" Running"),
          Spacer(),
        ],
      );
    } else {
      return Container();
    }
  }

//... for contaner width
  double contnerWidth(var start, var end) {
    if (end - start > 1 && end - start != 0 && end - start > 0) {
      return (end - start) * 100;
    } else {
      return 100;
    }
  }

//... if there is no class THEN RETUN Cross contaner
  Widget crossContainer(num start, num previous_end) {
    // .. calculate width
    double crossContanerWidth(num start, num previous_end) {
      num size = start - previous_end >= 2 ? start - previous_end - 1 : 0;

      return size * 100;
    }

    //
    if (start - previous_end >= 2) {
      return Container(
        height: 100,
        width: crossContanerWidth(start, previous_end),
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Colors.black, width: 1))),
        child: Container(
          decoration: BoxDecoration(
              color: getColor(weakdayIndex),
              borderRadius: BorderRadius.circular(3)),
          child: const Center(child: Icon(Icons.clear_rounded)),
        ),
      );
    } else {
      return Container();
    }
  }
}
