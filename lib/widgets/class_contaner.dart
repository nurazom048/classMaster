// ignore_for_file: must_be_immutable, camel_case_types, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    //
    DateTime newStart = getNewDateTime(startTime);
    DateTime newEnd = getNewDateTime(endTime);
    if (DateTime.now().isAfter(newStart) && DateTime.now().isBefore(newEnd)) {
      print("running  ${newStart.hour} - ${newEnd.hour}");
    } else {
      print("not running ${newStart.hour} - ${newEnd.hour}");
    }
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
            width: double.parse(contnerWidth(start, end).toString()),
            child: Container(
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.black, width: 1))),
              child: Column(
                children: [
                  Column(
                    children: [
                      _Running(newStart, newEnd),
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

//... for contaner width
  dynamic contnerWidth(var start, var end) {
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

  // date time formet by this
  DateTime getNewDateTime(DateTime givenTime) {
    DateTime now = DateTime.now();
    String month = "${now.month < 10 ? '0' : ''}${now.month}";
    String nowdays = "${now.day < 10 ? '0' : ''}${now.day}";

    String givenTime_hour =
        "${givenTime.hour < 10 ? '0' : ''}${givenTime.hour}";
    String givenTime_minute =
        "${givenTime.minute < 10 ? '0' : ''}${givenTime.minute}";

    DateTime newDateTime = DateTime.parse(
        "${now.year}-$month-$nowdays $givenTime_hour:$givenTime_minute:00");
    return newDateTime;
  }

  ///
  Widget _Running(DateTime newStart, DateTime newEnd) {
    // String formattStart = DateFormat.jm().format(newStart);
    // String formatt_end = DateFormat.jm().format(newEnd);

    //
    if (DateTime.now().isAfter(newStart) && DateTime.now().isBefore(newEnd)) {
      return SingleChildScrollView(
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(width: 5),
            const CircleAvatar(backgroundColor: Colors.red, radius: 4),
            const Text(
              " Running",
              maxLines: 2,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
          ],
        ),
      );
    } else {
      return const Text("");
    }
  }
}
