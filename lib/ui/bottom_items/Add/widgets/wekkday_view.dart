// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:table/models/rutins/class/find_class_model.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/dottted_divider.dart';

class WeekdayView extends StatelessWidget {
  final Weekday weekday;
  final dynamic onTap;

  WeekdayView({
    Key? key,
    required this.weekday,
    required this.onTap,
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
          color: const Color(0x0fa7cbff),
          border: Border.all(color: AppColor.nokiaBlue),
          borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(sevendays[weekday.num],
            style: TextStyle(fontSize: 18, color: AppColor.nokiaBlue)),
        trailing: InkWell(
            onTap: onTap, child: const Icon(Icons.delete, color: Colors.red)),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DotedDivider(),
          const SizedBox(height: 20),
          PeriodNumberSelector(
            hint: "Select Start Period",
            subhit: "Select End Period",
            lenghht: 3,
            onStartSelacted: (number) {
              print(number);
            },
            onEndSelacted: (number) {
              print(number);
            },
          ),
          const SizedBox(height: 20),
          Text(
            "   Classroom Number",
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          AppText(weekday.room).title(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
