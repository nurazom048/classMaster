import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriodeContaner extends StatelessWidget {
  final int priode;
  final DateTime startTime, endtime;

  final dynamic onTap;
  final IconData? iconn;
  final int lenght;
  const PriodeContaner({
    Key? key,
    required this.priode,
    required this.startTime,
    required this.endtime,
    this.onTap,
    this.iconn,
    required this.lenght,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(68, 114, 196, 40),
          border: Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Text({priode + 1}.toString()),
            const Divider(color: Colors.black87, height: 10, thickness: .5),
            Column(
              children: [
                Text(formatTime(startTime)),
                Text(formatTime(endtime)),
                Text(formatTimeDifference(startTime, endtime)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //

  String formatTimeDifference(DateTime startTime, DateTime endTime) {
    Duration difference = endTime.difference(startTime);
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }

  //
  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
