import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/models/class_details_model.dart';

import '../../../../../../widgets/appWidget/dottted_divider.dart';
import '../../../../../../widgets/heder/heder_title.dart';
import '../../widgets/rutin_box/rutin_card_row.dart';

class SummaryHeader extends StatelessWidget {
  final ClassId classId;
  final Day? day;

  const SummaryHeader({
    Key? key,
    required this.classId,
    this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime? time) {
      return DateFormat.jm().format(time ?? DateTime.now());
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderTitle("Routine", context),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Text(
                  '${formatTime(day?.startTime)}\n-\n${formatTime(day?.endTime)}',
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.1,
                    color: Color(0xFF4F4F4F),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 15),
                TitleAndSubtitle(
                  title: day?.classId.name ?? "Subject Name",
                  subtitle: day?.classId.subjectcode ?? "Room",
                ),
                const Spacer(),
                TitleAndSubtitle(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  title: day?.classId.instuctorName ?? "Instructor Name",
                  subtitle: '${day?.start}/${day?.end}',
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}
