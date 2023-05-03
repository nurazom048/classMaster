import 'package:flutter/material.dart';
import 'package:table/models/rutins/class/findClassModel.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';

import '../../../../helper/constant/AppColor.dart';

class ExpanedWeekDay extends StatelessWidget {
  final Weekday? weekday;
  final TextEditingController _roomController;

  ExpanedWeekDay({
    Key? key,
    required this.weekday,
    required TextEditingController roomController,
  })  : _roomController = roomController,
        super(key: key);

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
        title: Text(sevendays[weekday?.num ?? 0],
            style: TextStyle(fontSize: 18, color: AppColor.nokiaBlue)),
        trailing: const Icon(Icons.delete, color: Colors.red),
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
          AppTextFromField(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            controller: _roomController,
            hint: "Classroom Number",
            labelText: "Enter Classroom Number in this day",
            validator: (value) => AddClassValidator.roomNumber(value),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}