import 'package:classmate/core/widgets/appWidget/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:classmate/features/routine_Fetures/data/models/find_class_model.dart';
import 'package:classmate/features/routine_Fetures/presentation/utils/add_class_validation.dart';
import 'package:classmate/features/routine_Fetures/presentation/widgets/static_widgets/select_priode_number.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../../../core/widgets/appWidget/TextFromFild.dart';

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
        //title: Text(sevendays[weekday?.num ?? 0],
        title: Text('todo',
            style: TextStyle(fontSize: 18, color: AppColor.nokiaBlue)),
        trailing: const Icon(Icons.delete, color: Colors.red),
        children: [
          const DotedDivider(),
          const SizedBox(height: 20),
          PeriodNumberSelector(
            hint: "Select Start Period",
            subHint: "Select End Period",
            length: 3,
            onStartSelected: (number) {
              // ignore: avoid_print
              print(number);
            },
            onEndSelected: (number) {
              // ignore: avoid_print
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
