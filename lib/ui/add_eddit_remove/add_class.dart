// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/ui/widgets/select_time.dart';

import '../widgets/text and buttons/mytext.dart';

class AddClass extends StatefulWidget {
  String? dayname;

  AddClass({super.key, this.dayname});

  @override
  State<AddClass> createState() => _AddClassState();
}

//
final _instructorController = TextEditingController();
final _roomController = TextEditingController();
final _subCodeController = TextEditingController();
final _startTimeController = TextEditingController();
final _endTimeController = TextEditingController();
final _startPeriodController = TextEditingController();
final _endPeriodController = TextEditingController();

class _AddClassState extends State<AddClass> {
  final fromKey = GlobalKey<FormState>();

  DateTime startTime = DateTime(2022, 01, 01);
  DateTime endTime = DateTime(2022, 01, 01);

  bool show = false;

  //
  void addNewClass() {
    Map<String, dynamic> newclass = {
      "instructorname": _instructorController.text,
      "subjectcode": _startTimeController.text,
      "roomnum": _roomController.text,
      "startingpriode": double.parse(_startPeriodController.text),
      "endingpriode": double.parse(_endPeriodController.text),
      "start_time": startTime,
      "end_time": endTime,
      "weakday": _selectedDay,
    };
    Navigator.pop(context);
    Provider.of<MyRutinProvider>(context, listen: false).addclass(newclass);
  }

  List sevendays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  int _selectedDay = 1;
  // ignore: prefer_final_fields
  List<DropdownMenuItem<int>> _dayItems = const [
    DropdownMenuItem(
      child: Text('Sunday'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('Monday'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('Tuesday'),
      value: 3,
    ),
    DropdownMenuItem(
      child: Text('Wednesday'),
      value: 4,
    ),
    DropdownMenuItem(
      child: Text('Thursday'),
      value: 5,
    ),
    DropdownMenuItem(
      child: Text('Friday'),
      value: 6,
    ),
    DropdownMenuItem(
      child: Text('Saturday'),
      value: 7,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dayname ?? sevendays[0].toString())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              MyText("Select Day"),

              DropdownButtonFormField(
                value: _selectedDay,
                items: _dayItems,
                onChanged: (value) => setState(() => _selectedDay = value!),
                decoration: InputDecoration(
                  hintText: "Select a day",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: Colors.black12)),
                ),
              ),

              MyText("Instructor name"),
              TextFormField(
                controller: _instructorController,
                decoration: InputDecoration(
                  hintText: "Instructor name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "instractor name is requaid ";
                  }
                },
              ),

              ///

              MyText("Room name"),
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(
                  hintText: "Room name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Room number is required";
                  }
                },
              ),

              ///
              MyText("sub_code"),
              TextFormField(
                controller: _subCodeController,
                decoration: InputDecoration(
                  hintText: "subject code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),

              //

              MyText(" Start and end time "),

              Row(
                children: [
                  Expanded(
                    child: SelectTime(
                      time_text: "start_time",
                      time: startTime,
                      show: show,
                      onTap: () => _selectStartTime(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SelectTime(
                      time_text: "end time",
                      time: endTime,
                      show: show,
                      onTap: _selectEndTime,
                    ),
                  ),
                ],
              ),

              //

              MyText(" Start and end Priode"),

              //
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        controller: _startPeriodController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                          ),
                          hintText: "Start priode",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "End period cannot be empty";
                          } else if (value.runtimeType != int) {
                            return "must be an integer";
                          } else if (int.parse(_startPeriodController.text) <
                              int.parse(value)) {
                            return "end priode should be greater than start period";
                          } else {
                            return "";
                          }
                        }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      controller: _endPeriodController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        hintText: "End priode",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "End period cannot be empty";
                        } else if (value.runtimeType != int) {
                          return "must be an integer";
                        } else if (int.parse(value) <
                            int.parse(_startPeriodController.text)) {
                          return "end priode should be greater than start period";
                        } else {
                          return "";
                        }
                      },
                    ),
                  ),
                ],
              ),

              //.............. Submit botton ..............//
              const Spacer(flex: 3),
              Align(
                alignment: Alignment.center,
                child: CupertinoButton(
                  child: const Text("Submit"),
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7),
                  onPressed: (() {
                    final isvalidfrom = fromKey.currentState!.validate();
                    if (isvalidfrom) {
                      addNewClass();
                    }
                  }),
                ),
              ),

              const Spacer(flex: 17),
            ],
          ),
        ),
      ),
    );
  }

  // //....... star time
  void _selectStartTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          show = true;
          startTime = DateTime(2023, 01, 01, value.hour, value.minute)
              .add(const Duration(days: 0));
        });
      }
    });
  }

  //--- end time
  void _selectEndTime() {
    showTimePicker(
            context: context,
            initialTime:
                TimeOfDay(hour: startTime.hour, minute: startTime.minute))
        .then((value) {
      if (value != null) {
        setState(() {
          show = true;

          endTime = DateTime(2022, 01, 02, value.hour, value.minute)
              .add(const Duration(days: 0));
        });
      }
    });
  }
}
