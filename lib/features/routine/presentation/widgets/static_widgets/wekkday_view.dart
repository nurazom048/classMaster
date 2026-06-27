// ignore_for_file: avoid_print

import 'package:classmate/features/routine/presentation/widgets/static_widgets/select_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine/data/models/find_class_model.dart';
import '../../../../../core/constant/app_color.dart';
import '../../../../../core/widgets/appWidget/app_text.dart';
import '../../../../../core/widgets/appWidget/dotted_divider.dart';
import '../../../data/models/weekday_model.dart';

class WeekdayView extends ConsumerWidget {
  final Weekday weekday;
  final dynamic onTap;
  final dynamic showDeleteButton;

  const WeekdayView({
    super.key,
    required this.weekday,
    required this.onTap,
    required this.showDeleteButton,
  });

  // map of short day names to full day names
  final Map<String, String> fullDayNames = const {
    "sun": "Sunday",
    "mon": "Monday",
    "tue": "Tuesday",
    "wed": "Wednesday",
    "thu": "Thursday",
    "fri": "Friday",
    "sat": "Saturday",
  };

  // function to get full day name from short name
  String _getFullDayName(String? shortName) {
    if (shortName == null || shortName.isEmpty) return "Unknown Day";
    return fullDayNames[shortName.toLowerCase()] ?? shortName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0x0fa7cbff),
        border: Border.all(color: AppColor.nokiaBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        // here will show the full day name instead of short name
        title: Text(
          _getFullDayName(weekday.weekday),
          style: TextStyle(
            fontSize: 18,
            color: AppColor.nokiaBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            showDeleteButton == true
                ? InkWell(
                  onTap: onTap,
                  child: const Icon(Icons.delete, color: Colors.red),
                )
                : const SizedBox(),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DotedDivider(),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectTime(
                    width: size.width * 0.40,
                    timeText: 'Start Time',
                    time: weekday.startTime,
                    show: true,
                    onTap: () {},
                  ),
                  SelectTime(
                    width: size.width * 0.40,
                    timeText: 'End Time',
                    time: weekday.endTime,
                    show: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Classroom Number",
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    height: 1.3,
                    color: AppColor.nokiaBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(weekday.room, style: TS.heading()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
