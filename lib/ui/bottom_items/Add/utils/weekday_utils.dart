// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/constant/app_color.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:classmate/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:flutter/material.dart' as ma;
import 'package:classmate/widgets/appWidget/buttons/cupertino_buttons.dart';

import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/day_select_dropdowen.dart';
import '../../Home/Full_routine/controller/weekday_controller.dart';
import '../../Home/Full_routine/screen/viewMore/class_list.dart';

// ignore: must_be_immutable
class AddWeekdayExpansion extends ConsumerWidget {
  final String classId;
  AddWeekdayExpansion({super.key, required this.classId});
  final TextEditingController _roomCon = TextEditingController();

  final _weekdayFromKey = GlobalKey<FormState>();
  int _start = 1;
  int _end = 1;
  int? _number;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //total
    final totalPriode = ref.watch(totalPriodeCountProvider);

    return Scaffold(
      backgroundColor: Colors.black12.withOpacity(0.3),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
                .copyWith(bottom: 200),
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: Colors.black,
            child: Form(
              key: _weekdayFromKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 9),
                    height: 40,
                    // color: Colors.red,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  ),
                  DayDropdown(
                    labelText: "select day",
                    onPressed: () {},
                    onChanged: (selectedDay) {
                      _number = selectedDay;
                    },
                  ),
                  const SizedBox(height: 5),
                  PeriodNumberSelector(
                    hint: " Select Start Period",
                    subHint: " Select End Period",
                    length: totalPriode,
                    onEndSelected: (number) {
                      _start = number;
                    },
                    onStartSelected: (number) {
                      _end = number;
                    },
                  ),
                  AppTextFromField(
                    controller: _roomCon,
                    hint: "Classroom Number",
                    labelText: "Enter Classroom Number in this day",
                    keyboardType: TextInputType.text,
                    validator: (value) => AddClassValidator.roomNumber(value),
                  ),
                  const SizedBox(height: 30),
                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    text: "Add Weekday",
                    widget: const ma.Text(
                      "Add Weekday",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    color: AppColor.nokiaBlue,
                    onPressed: () async {
                      if (_number == null) {
                        Alert.errorAlertDialog(context, 'Select day');
                      }
                      if (_weekdayFromKey.currentState!.validate() &&
                          _number != null) {
                        ref
                            .watch(weekdayControllerStateProvider(classId)
                                .notifier)
                            .addWeekday(
                              context,
                              ref,
                              _number.toString(),
                              _roomCon.text,
                              _start.toString(),
                              _end.toString(),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            )),
      ),
    );
  }
}
