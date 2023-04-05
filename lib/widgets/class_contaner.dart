// ignore_for_file: must_be_immutable, camel_case_types, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassContainer extends StatelessWidget {
  final String? instractorname, roomnum, subCode, classname;
  final String? has_class;
  final num start, end, previous_end;
  final DateTime? startTime, endTime;
  final dynamic weakday;
  final dynamic onTap, onLongPress;
  final dynamic weakdayIndex;
  final bool isLast;
  final int priodeLenght;

  const ClassContainer({
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
    required this.priodeLenght,

    //
    this.onTap,
    this.onLongPress,
    required this.weakdayIndex,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        crossContainer(end, previous_end),
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
                      running(startTime ?? DateTime.now(),
                          endTime ?? DateTime.now()),
                      Text(instractorname ?? ""),
                      Text(subCode ?? ""),
                      Text(roomnum ?? ""),
                      // Text(
                      //     "${previous_end == 1 || previous_end == start ? 0 : previous_end} $start")
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        EndcrossContainer(end, priodeLenght, isLast),
      ],
    );
  }

  ///.... for changling color....//
  Color getColor(int indexofdate) {
    return indexofdate.isOdd
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
  Widget crossContainer(num end, num previous_end) {
    num misingPriode = (previous_end - end);
    num startMisingContaner = start - 1;
    num size = misingPriode.isNegative == false
        ? startMisingContaner.isNegative == false
            ? startMisingContaner
            : misingPriode
        : 0;

    double width = size * 100;

    return size.isNegative
        ? const SizedBox.shrink()
        : Container(
            height: 100,
            width: width, // .. calculate width
            decoration: const BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.black, width: 1))),
            child: Container(
              decoration: BoxDecoration(
                  color: getColor(weakdayIndex),
                  borderRadius: BorderRadius.circular(3)),
              child: const Center(child: Icon(Icons.clear_rounded)),
            ),
          );
  }

//... if there is no class THEN RETUN Cross contaner
  Widget EndcrossContainer(num end, dynamic priodeLenght, bool islast) {
    num misingPriode = priodeLenght - end;
    num size = (misingPriode >= 0 && isLast == true) ? misingPriode : 0;

    if (size == 0) return const SizedBox.shrink();
    return Container(
      height: 100,
      width: size * 100, // .. calculate width
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black, width: 1))),
      child: Container(
        decoration: BoxDecoration(
            color: getColor(weakdayIndex),
            borderRadius: BorderRadius.circular(3)),
        child: const Center(child: Icon(Icons.clear_rounded)),
      ),
    );
  }
}

// date time formet by this
DateTime getNewDateTime(DateTime givenTime) {
  DateTime now = DateTime.now();
  String month = "${now.month < 10 ? '0' : ''}${now.month}";
  String nowdays = "${now.day < 10 ? '0' : ''}${now.day}";

  String givenTime_hour = "${givenTime.hour < 10 ? '0' : ''}${givenTime.hour}";
  String givenTime_minute =
      "${givenTime.minute < 10 ? '0' : ''}${givenTime.minute}";

  DateTime newDateTime = DateTime.parse(
      "${now.year}-$month-$nowdays $givenTime_hour:$givenTime_minute:00");
  return newDateTime;
}

///
Widget running(DateTime startTime, DateTime end_time) {
  DateTime current = DateTime.now().toLocal();
  DateTime newST = DateTime(current.year, current.month, current.day,
      startTime.hour, startTime.minute, 0);
  DateTime newET = DateTime(current.year, current.month, current.day,
      end_time.hour, end_time.minute, 0);

  //
  if (current.isAfter(newST) && current.isBefore(newET)) {
    return SingleChildScrollView(
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const SizedBox(width: 5),
          const CircleAvatar(
              backgroundColor: CupertinoColors.systemRed, radius: 4),
          const Text(
            " Running",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CupertinoColors.systemRed,
              fontFamily: 'Cupertino', // Set font family to Cupertino
              fontWeight: FontWeight.w400, // Set font weight to bold
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  } else {
    return const Text("");
  }
}
