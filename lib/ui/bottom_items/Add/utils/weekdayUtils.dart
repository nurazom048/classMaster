// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/app_color.dart';
import 'package:table/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:table/ui/bottom_items/Add/widgets/select_priode_number.dart';
import 'package:flutter/material.dart' as ma;
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';

import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/daySelectDropdowen.dart';
import '../../Home/full_rutin/controller/weekday_controller.dart';

class WeekdayUtils {
  //! add weekday
  static void addWeekday(BuildContext context, classId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int _start = 1;
          int _end = 1;
          int? _number;
          final _roomCon = TextEditingController();
          final _weekdayFromKey = GlobalKey<FormState>();

          return AlertDialog(
            content: SingleChildScrollView(
              child: Form(
                key: _weekdayFromKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DayDropdown(
                        labelText: "select day",
                        onPressed: () {},
                        onChanged: (selectedDay) {
                          _number = selectedDay;
                        }),
                    const SizedBox(height: 5),
                    PeriodNumberSelector(
                      hint: " Select Start Period",
                      subhit: " Select End Period",
                      lenghht: 3,
                      onStartSelacted: (number) {
                        _start = number;
                      },
                      onEndSelacted: (number) {
                        _end = number;
                      },
                    ),
                    AppTextFromField(
                      controller: _roomCon,
                      hint: "Classroom Number",
                      labelText: "EnterClassroom Number in this day",
                      validator: (value) => AddClassValidator.roomNumber(value),
                    ),
                    const SizedBox(height: 30),
                    Consumer(builder: (context, ref, _) {
                      return CupertinoButtonCustom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        textt: "Add Weekday",
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
                          print("object");
                          if (_weekdayFromKey.currentState!.validate() &&
                              _number != null) {
                            print("validate");
                            ref
                                .watch(weekayControllerStateProvider(classId)
                                    .notifier)
                                .addWeekday(
                                    context,
                                    ref,
                                    _number.toString(),
                                    _roomCon.text,
                                    _start.toString(),
                                    _end.toString());
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
