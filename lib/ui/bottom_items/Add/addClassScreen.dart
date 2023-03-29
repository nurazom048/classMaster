// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Add/request/class_request.dart';
import 'package:table/widgets/MyTextFields.dart';
import 'package:table/widgets/select_time.dart';
import 'package:table/widgets/text%20and%20buttons/butonCustom.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';
import '../../../core/dialogs/Alart_dialogs.dart';
import '../../../helper/constant/constant.dart';
import '../../../models/class_model.dart';
import '../../../widgets/daySelectDropdowen.dart';

class AddClassSceen extends StatefulWidget {
  String rutinId;
  String? classId;
  bool? isEdit;
  AddClassSceen(
      {super.key, required this.rutinId, this.classId, this.isEdit = false});

  @override
  State<AddClassSceen> createState() => _AddClassSceenState();
}

class _AddClassSceenState extends State<AddClassSceen> {
  //
  final _className = TextEditingController();
  final _instructorController = TextEditingController();
  final _roomController = TextEditingController();
  final _subCodeController = TextEditingController();
  final _startPeriodController = TextEditingController();
  final _endPeriodController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime startTime = DateTime.now();
  late DateTime endTime = DateTime.now().add(Duration(minutes: 30));

  bool show = false;

  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimDemo = DateTime.now();

  int _selectedDay = 1;

  //
  // find class
  Future<void> findClass() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.get(
          Uri.parse('${Const.BASE_URl}/class/find/class/${widget.classId}'),
          headers: {'Authorization': 'Bearer $getToken'});

      print(response.statusCode);
      //.. responce
      if (response.statusCode == 200) {
        var decodedres = json.decode(response.body);
        print(decodedres);
        //
        _className.text = json.decode(response.body)["classs"]["name"];
        _instructorController.text =
            json.decode(response.body)["classs"]["instuctor_name"];
        _roomController.text = json.decode(response.body)["classs"]["room"];
        _subCodeController.text =
            json.decode(response.body)["classs"]["subjectcode"];

        //
        setState(() {
          _selectedDay = json.decode(response.body)["classs"]["weekday"];
          startTime = DateTime.parse(
              json.decode(response.body)["classs"]["start_time"]);
          endTime =
              DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

          //
          startTimeDemo = DateTime.parse(
              json.decode(response.body)["classs"]["start_time"]);
          endTimDemo =
              DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

          show = true;

          //
          _startPeriodController.text =
              json.decode(response.body)["classs"]["start"].toString();
          _endPeriodController.text =
              json.decode(response.body)["classs"]["end"].toString();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      findClass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add class')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const MyText("Select Day"),

              DayDropdown(
                  labelText: "select day",
                  initialDay: 7,
                  onChanged: (day) {
                    setState(() {
                      _selectedDay = day ?? 1;
                    });
                    print(_selectedDay.toString());
                  }),

              ///...Class name
              MyTextField(
                name: "Class name",
                controller: _className,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User Name Required';
                  }
                  return null;
                },
              ),

              ///...Instructor name
              MyTextField(
                name: "Instructor namer",
                controller: _instructorController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User Name Required';
                  }
                  return null;
                },
              ),

              ///.... room number
              MyTextField(
                name: "room number",
                controller: _roomController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User Name Required';
                  }
                  return null;
                },
              ),
              MyTextField(
                name: "sub_code",
                controller: _subCodeController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User Name Required';
                  }
                  return null;
                },
              ),

              //

              const MyText(" Start and end time "),

              Row(
                children: [
                  SelectTime(
                    width: MediaQuery.of(context).size.width / 2.1,
                    time_text: "start_time",
                    time: startTimeDemo,
                    show: show,
                    onTap: () => _selectStartTime(),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: SelectTime(
                      width: MediaQuery.of(context).size.width / 2.1,
                      time_text: "end time",
                      time: endTimDemo,
                      show: show,
                      onTap: _selectEndTime,
                    ),
                  ),
                ],
              ),

              const MyText("Start and end Priode"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
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
                        hintText: "Start period",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Start period cannot be empty";
                        } else if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "Start period must be a positive integer";
                        } else {
                          int start = int.parse(value);
                          int end =
                              int.tryParse(_endPeriodController.text) ?? 0;
                          if (start > end) {
                            return "Start period must be less than end period";
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
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
                        hintText: "End period",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "End period cannot be empty";
                        } else if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "End period must be a positive integer";
                        } else {
                          int start =
                              int.tryParse(_startPeriodController.text) ?? 0;
                          int end = int.parse(value);
                          if (start > end) {
                            return "End period must be greater than start period";
                          }
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                alignment: Alignment.center,
                child: ButtomCustom(
                  text:
                      Text(widget.isEdit == true ? "Edit Class" : "add class"),
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      print("ok validate ");
                      print(widget.classId);
                      widget.isEdit == true
                          ? ClassRequest().editClass(
                              context,
                              widget.classId ?? "",
                              ClassModel(
                                className: _className.text,
                                instructorName: _instructorController.text,
                                roomNumber: _roomController.text,
                                subjectCode: _subCodeController.text,
                                startingPeriod:
                                    int.parse(_startPeriodController.text),
                                endingPeriod:
                                    int.parse(_endPeriodController.text),
                                weekday: _selectedDay,
                                startTime: startTime,
                                endTime: endTime,
                              ))
                          : ClassRequest().addClass(
                              widget.rutinId,
                              context,
                              ClassModel(
                                className: _className.text,
                                instructorName: _instructorController.text,
                                roomNumber: _roomController.text,
                                subjectCode: _subCodeController.text,
                                startingPeriod:
                                    int.parse(_startPeriodController.text),
                                endingPeriod:
                                    int.parse(_endPeriodController.text),
                                weekday: _selectedDay,
                                startTime: startTime,
                                endTime: endTime,
                              ));
                    }
                  },
                ),
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  void _selectStartTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selecteTime = DateTime.parse("2021-12-23 $hour:$minute:00Z");

        print("houre : ${value.hour} ,munite ${value.minute}");

        setState(() {
          show = true;
          startTime = selecteTime;
          startTimeDemo = selecteTime;
          print(startTime.toIso8601String());
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
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selecteEndTime =
            DateTime.parse("2021-12-23 $hour:$minute:00Z");
        //
        setState(() {
          show = true;

          endTime = selecteEndTime;
          endTimDemo = selecteEndTime;
          print(endTime.toIso8601String());
        });
      }
    });
  }
}
