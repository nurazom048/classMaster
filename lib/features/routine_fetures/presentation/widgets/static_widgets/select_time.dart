// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/appWidget/app_text.dart';

class SelectTime extends StatelessWidget {
  bool show;
  dynamic onTap;
  late DateTime time;
  final double width;
  final String timeText;
  SelectTime(
      {super.key,
      required this.onTap,
      required this.timeText,
      required this.time,
      required this.show,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(timeText).heeding(),
        const SizedBox(height: 10),
        Container(
          height: 50,
          width: width,
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
                  show ? DateFormat.jm().format(time) : timeText,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(flex: 4),
                const Icon(Icons.timer_outlined),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
