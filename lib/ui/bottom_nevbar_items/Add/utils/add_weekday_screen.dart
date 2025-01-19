// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result

import 'package:classmate/ui/bottom_nevbar_items/Home/Full_routine/widgets/select_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/constant/app_color.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_nevbar_items/Add/utils/add_class_validation.dart';
import 'package:classmate/widgets/appWidget/buttons/cupertino_buttons.dart';

import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/day_select_dropdowen.dart';
import '../../Home/Full_routine/controller/weekday_controller.dart';

class AddWeekdayScreen extends StatefulWidget {
  final String classId;

  const AddWeekdayScreen({super.key, required this.classId});

  @override
  State<AddWeekdayScreen> createState() => _AddWeekdayScreenState();
}

class _AddWeekdayScreenState extends State<AddWeekdayScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> weekdayFormKey = GlobalKey<FormState>();
  final TextEditingController roomController = TextEditingController();

  bool showStartTime = false;
  bool showEndTime = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(minutes: 30));
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: Consumer(builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
                .copyWith(bottom: 200),
            width: size.width,
            child: Form(
              key: weekdayFormKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 9),
                    height: 40,
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
                      labelText: "Tap Here",
                      onPressed: () {},
                      onChanged: (day) {
                        selectedDay = day;
                      }),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectTime(
                        width: size.width * 0.45,
                        timeText: 'Start Time',
                        time: startTime,
                        show: showStartTime,
                        onTap: () => _selectStartTime(context),
                      ),
                      const SizedBox(width: 5),
                      SelectTime(
                        width: size.width * 0.45,
                        timeText: 'End Time',
                        time: endTime,
                        show: showEndTime,
                        onTap: () => _selectEndTime(context),
                      ),
                    ],
                  ),
                  AppTextFromField(
                    controller: roomController,
                    hint: "Classroom Number",
                    labelText: "Enter Classroom Number",
                    keyboardType: TextInputType.text,
                    validator: (value) => AddClassValidator.roomNumber(value),
                  ),
                  const SizedBox(height: 30),
                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    text: "Add Weekday",
                    widget: const Text(
                      "Add Weekday",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    color: AppColor.nokiaBlue,
                    onPressed: () async {
                      // Validation checks
                      if (selectedDay == null) {
                        Alert.errorAlertDialog(context, 'Select Day');
                      } else if (roomController.text.isEmpty) {
                        Alert.errorAlertDialog(
                            context, 'Enter Classroom Number');
                      } else if (weekdayFormKey.currentState!.validate()) {
                        ref
                            .watch(
                                weekdayControllerStateProvider(widget.classId)
                                    .notifier)
                            .addWeekday(
                              context,
                              ref,
                              selectedDay.toString(),
                              roomController.text,
                              startTime,
                              endTime,
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _selectStartTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    ).then((value) {
      if (value != null) {
        setState(() {
          showStartTime = true;
          startTime = DateTime(
            startTime.year,
            startTime.month,
            startTime.day,
            value.hour,
            value.minute,
          );
        });
      }
    });
  }

  void _selectEndTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    ).then((value) {
      if (value != null) {
        setState(() {
          showEndTime = true;
          endTime = DateTime(
            endTime.year,
            endTime.month,
            endTime.day,
            value.hour,
            value.minute,
          );
        });
      }
    });
  }
}
