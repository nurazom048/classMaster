// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/rutins/class/find_class_model.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/dottted_divider.dart';
import '../../Home/full_rutin/screen/viewMore/class_list.dart';

class WeekdayView extends ConsumerWidget {
  final Weekday weekday;
  final dynamic onTap;
  final dynamic showDeleteButton;

  WeekdayView({
    Key? key,
    required this.weekday,
    required this.onTap,
    required this.showDeleteButton,
  }) : super(key: key);

  final List<String> sevendays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //total propde
    final totalPriode = ref.watch(totalPriodeCountProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: const Color(0x0fa7cbff),
          border: Border.all(color: AppColor.nokiaBlue),
          borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(sevendays[weekday.num],
            style: TextStyle(fontSize: 18, color: AppColor.nokiaBlue)),
        trailing: showDeleteButton == true
            ? InkWell(
                onTap: onTap,
                child: const Icon(Icons.delete, color: Colors.red))
            : const SizedBox(),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DotedDivider(),
          const SizedBox(height: 20),
          PeriodNumberSelector(
            viewOnly: true,
            hint: "Select Start Period",
            subHint: "Select End Period",
            length: totalPriode,
            onStartSelected: (number) {
              print(number);
            },
            onEndSelected: (number) {
              print(number);
            },
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
                      color: AppColor.nokiaBlue),
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
