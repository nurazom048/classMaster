// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/export_core.dart';
import '../../../../routine_Fetures/presentation/widgets/dynamic_widgets/routine_card_row.dart';

class SummaryHeader extends StatelessWidget {
  final String classId;
  final String? className;
  final String? instructorName;
  final String subjectCode;
  //
  final DateTime? startTime;
  final DateTime? endTime;
  final int? start;
  final int? end;
  final String? room;

  const SummaryHeader({
    super.key,
    required this.classId,
    this.className,
    this.instructorName,
    required this.subjectCode,
    //
    this.startTime,
    this.endTime,
    this.start,
    this.end,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime? time) {
      return DateFormat.jm().format(time ?? DateTime.now());
    }

    return SizedBox(
      // padding: const EdgeInsets.only(bottom: 15),
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitle(
            "Summary",
            context,
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 8,
            ).copyWith(right: 1),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (startTime != null && endTime != null)
                      Text(
                        '${formatTime(startTime)}\n      -\n${formatTime(endTime)}',
                        textScaleFactor: 1.2,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.1,
                          color: Color(0xFF4F4F4F),
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    const SizedBox(width: 5),
                    TitleAndSubtitle(
                      title: className ?? "Subject Name",
                      subtitle: room ?? "room name",
                    ),
                  ],
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        start == null
                            ? "code - $subjectCode"
                            : '$instructorName',
                        overflow: TextOverflow.ellipsis,
                        style: TS.opensensBlue(color: Colors.black),
                      ),
                      Text(
                        instructorName ?? "Instructor Name",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}
