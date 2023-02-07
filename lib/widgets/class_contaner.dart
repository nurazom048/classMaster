// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';

class ClassContainer extends StatelessWidget {
  String instractorname, roomnum, subCode;
  String? has_class;
  num start, end;
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

    double contanerwith = 100;
//... foe Contaner with...//
    if (end - start > 1 && end - start != 0 && end - start > 0) {
      contanerwith = (end - start) * 100;
    }
    return Row(
      children: [
        InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          //onTap: has_class == "no_class" ? onTap ?? () {} : () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: getColor(weakdayIndex)),
            height: 100,
            width: contanerwith,
            child: has_class == "no_class"
                ? const Center(
                    child: Icon(Icons.clear_rounded),
                  )
                : Column(
                    children: [
                      checkIfRunning(startTime, endTime, weakday),
                      const Spacer(),
                      /////
                      Column(
                        children: [
                          Text(startTime.toString()),
                          Text(weakday.toString()),
                          Text(subCode),
                        ],
                      ),
                      const Spacer(),
                    ],
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
}
