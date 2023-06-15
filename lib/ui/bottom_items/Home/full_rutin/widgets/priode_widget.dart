import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/appWidget/app_text.dart';

class PriodeWidget extends StatelessWidget {
  const PriodeWidget({
    required this.startTime,
    required this.endTime,
    required this.priodeNumber,
    required this.onLongpress,
    super.key,
  });

  final DateTime startTime, endTime;
  final num priodeNumber;
  final dynamic onLongpress;
  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime dateTime) {
      return DateFormat('h:mm a').format(dateTime);
    }

    // ignore: avoid_print
    print("is running ${running(startTime, endTime)}");
    Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return InkWell(
      onLongPress: onLongpress,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: 110,
        width: 130,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              child: InkWell(
                child: Container(
                    height: 92,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 130,
                    decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 10),
                        AppText(formatTime(startTime)).heding(),
                        AppText(formatTime(endTime)).heding(),
                      ],
                    )),
              ),
            ),

            //
            Positioned(
              top: 4,
              right: 38,
              child: Container(
                width: 57,
                height: 57,
                color: scaffoldBackgroundColor,
                child: Container(
                  width: 55,
                  height: 55,
                  //  margin: EdgeInsets.only(top: 324, left: 55),
                  decoration: running(startTime, endTime) == true
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF0168FF),
                              Colors.white,
                              Colors.white,
                            ],
                            stops: [0, 1, 1],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        )
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                  child: Center(
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: scaffoldBackgroundColor,
                      child: Wrap(direction: Axis.horizontal, children: [
                        Text(
                          "$priodeNumber",
                          style: TS.opensensBlue(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          getSuffix(priodeNumber.toInt()),
                          style: const TextStyle(
                              fontFeatures: [FontFeature.superscripts()]),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// date time formet by this
  DateTime getNewDateTime(DateTime givenTime) {
    DateTime now = DateTime.now();
    String month = "${now.month < 10 ? '0' : ''}${now.month}";
    String nowdays = "${now.day < 10 ? '0' : ''}${now.day}";

    String giventimeHour = "${givenTime.hour < 10 ? '0' : ''}${givenTime.hour}";
    String giventimeMinute =
        "${givenTime.minute < 10 ? '0' : ''}${givenTime.minute}";

    DateTime newDateTime = DateTime.parse(
        "${now.year}-$month-$nowdays $giventimeHour:$giventimeMinute:00");
    return newDateTime;
  }

  ///
  bool running(DateTime startTime, DateTime endTime) {
    DateTime current = DateTime.now().toLocal();
    DateTime newST = DateTime(current.year, current.month, current.day,
        startTime.hour, startTime.minute, 0);
    DateTime newET = DateTime(current.year, current.month, current.day,
        endTime.hour, endTime.minute, 0);

    //
    if (current.isAfter(newST) && current.isBefore(newET)) {
      return true;
    } else {
      return false;
    }
  }

  String getSuffix(int n) {
    if (n >= 11 && n <= 13) {
      return 'th';
    }
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
