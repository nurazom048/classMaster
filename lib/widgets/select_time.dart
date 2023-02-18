// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectTime extends StatelessWidget {
  bool show;
  dynamic onTap;
  late DateTime time;
  String time_text;
  SelectTime(
      {super.key,
      required this.onTap,
      required this.time_text,
      required this.time,
      required this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.all(11),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const Spacer(flex: 1),
            Text(
              show ? DateFormat.jm().format(time) : time_text,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(flex: 4),
            const Icon(Icons.timer_outlined),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
