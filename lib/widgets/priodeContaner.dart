import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriodeContaner extends StatelessWidget {
  final int priode;
  final int previusPriode;
  final DateTime startTime, endtime;

  final dynamic onLongPress;
  final IconData? iconn;
  final int lenght;
  final int index;

  const PriodeContaner({
    Key? key,
    required this.priode,
    required this.startTime,
    required this.endtime,
    required this.previusPriode,
    this.onLongPress,
    this.iconn,
    required this.index,
    required this.lenght,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress ?? () {},
      child: Row(
        children: [
          crossContainerPriode(priode, previusPriode),
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(68, 114, 196, 40),
                border:
                    Border(right: BorderSide(color: Colors.black45, width: 1))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Text({priode}.toString()),
                  const Divider(
                      color: Colors.black87, height: 10, thickness: .5),
                  Column(
                    children: [
                      Text(formatTime(startTime)),
                      Text(formatTime(endtime)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

//... if there is no class THEN RETUN Cross contaner
  Widget crossContainerPriode(num currentPriodeNumber, num priviusPriodeNum) {
    num size = (currentPriodeNumber - priviusPriodeNum);

    double width = size * 100;

    return size.isNegative || width == 0 || size == 1
        ? const SizedBox.shrink()
        : Row(
            children: [
              for (var i = priviusPriodeNum + 1;
                  i <= currentPriodeNumber - 1;
                  i++)
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(68, 114, 196, 40),
                    border: Border(
                      right: BorderSide(color: Colors.black45, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text("($i)"),
                        const Divider(
                          color: Colors.black87,
                          height: 10,
                          thickness: .5,
                        ),
                        const Icon(Icons.clear),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }
}
