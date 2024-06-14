// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result

import 'package:classmate/ui/bottom_items/Home/Full_routine/widgets/select_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/constant/app_color.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Add/utils/add_class_validation.dart';
import 'package:flutter/material.dart' as ma;
import 'package:classmate/widgets/appWidget/buttons/cupertino_buttons.dart';

import '../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../widgets/day_select_dropdowen.dart';
import '../../Home/Full_routine/controller/weekday_controller.dart';

// ignore: must_be_immutable
class AddWeekdayPopUp extends StatefulWidget {
  final String classId;
  const AddWeekdayPopUp({
    Key? key,
    required this.classId,
  });
  @override
  State<AddWeekdayPopUp> createState() => _AddWeekdayPopUpState();
}

class _AddWeekdayPopUpState extends State<AddWeekdayPopUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //

  bool showStartTime = false;
  bool showEndTime = false;
  DateTime? st;
  DateTime? et;
  // Text editing controllers
  final _roomController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Default start and end times
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now().add(const Duration(minutes: 30));

  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimeDemo = DateTime.now();

  // Selected day of the week
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // variables
    final _weekdayFromKey = GlobalKey<FormState>();
    final Size size = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, child) {
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
                      labelText: "Tap Here",
                      onPressed: () {},
                      onChanged: (selectedDay) {
                        _selectedDay = selectedDay;
                      },
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectTime(
                              width: size.width * 0.40,
                              timeText: 'Start Time',
                              time: startTime,
                              show: showStartTime,
                              onTap: () {
                                _selectStartTime(
                                    _scaffoldKey.currentContext ?? context);
                              },
                            ),
                            SelectTime(
                              width: size.width * 0.40,
                              timeText: 'End Time',
                              time: endTime,
                              show: showEndTime,
                              onTap: () => _selectEndTime(
                                  _scaffoldKey.currentContext ?? context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppTextFromField(
                      controller: _roomController,
                      hint: "Classroom Number",
                      labelText: "",
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
                        //Null check For Validation part
                        if (_selectedDay == null) {
                          Alert.errorAlertDialog(context, 'Select Day ');
                        } else if (_roomController.text == '') {
                          Alert.errorAlertDialog(
                              context, 'Select Classroom Number ');
                        } else if (startTime == null) {
                          Alert.errorAlertDialog(context, 'Select Start Time ');
                        } else if (endTime == null) {
                          Alert.errorAlertDialog(context, 'Select End Time ');
                        }
                        // print('select day ${_selectedDay.toString()} ');
                        // print('room ${_roomController.text.toString()}');
                        // print('startTime  ${_startTime.toString()}');
                        // print('end time ${_endTime.toString()}');

                        if (_weekdayFromKey.currentState!.validate() &&
                            startTime != null &&
                            endTime != null) {
                          ref
                              .watch(
                                  weekdayControllerStateProvider(widget.classId)
                                      .notifier)
                              .addWeekday(
                                context,
                                ref,
                                _selectedDay.toString(),
                                _roomController.text,
                                startTime!,
                                endTime!,
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
    });
  }

  void _selectStartTime(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime),
    ).then((value) {
      if (value != null) {
        setState(() {
          showStartTime = true;
          startTime = DateTime(startTime.year, startTime.month, startTime.day,
              value.hour, value.minute);

          print(startTime);
        });
      }
    });
  }

  void _selectEndTime(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endTime),
    ).then((value) {
      if (value != null) {
        DateTime selectedEndTime = DateTime(
            endTime.year, endTime.month, endTime.day, value.hour, value.minute);

        setState(() {
          showEndTime = true;
          endTime = selectedEndTime;
          endTimeDemo = selectedEndTime;
        });
      }
    });
  }
}
