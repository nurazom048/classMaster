import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/models/class_details_model.dart';

import '../../../../../../widgets/appWidget/dottted_divider.dart';
import '../../../../../../widgets/heder/heder_title.dart';
import '../../widgets/rutin_box/rutin_card_row.dart';

class SummaryHeader extends StatelessWidget {
  final String classId;
  final String? className;
  final String? subjectCode;
  final String? instructorName;

  const SummaryHeader({
    Key? key,
    required this.classId,
    this.className,
    this.subjectCode,
    this.instructorName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime? time) {
      return DateFormat.jm().format(time ?? DateTime.now());
    }

    return Container(
      // padding: const EdgeInsets.only(bottom: 15),
      height: 132,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitle("Summary", context,
              margin: const EdgeInsets.only(top: 20, left: 20, bottom: 8)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // Text(
                //   '${formatTime(day?.startTime)}\n-\n${formatTime(day?.endTime)}',
                //   textScaleFactor: 1.2,
                //   style: const TextStyle(
                //     fontFamily: 'Inter',
                //     fontWeight: FontWeight.w500,
                //     fontSize: 12,
                //     height: 1.1,
                //     color: Color(0xFF4F4F4F),
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // const SizedBox(width: 15),
                TitleAndSubtitle(
                  title: className ?? "Subject Name",
                  subtitle: subjectCode ?? "subjectname",
                ),
                const Spacer(),
                TitleAndSubtitle(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  title: "Instructor Name",
                  subtitle: instructorName ?? '',
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
