// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';
import 'package:table/widgets/MyTextFields.dart';
import 'package:table/widgets/select_time.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: LoginScreen(),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register User'),
      ),
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
                    print(day.toString());
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
                          if (start >= end) {
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
                          if (start >= end) {
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      print("ok validate ");
                    }
                  },
                  child: const Text("Register Now"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _endPeriodValidator(String? value) {
    if (value!.isEmpty) {
      return "End period cannot be empty";
    } else if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return "End period must be a positive integer";
    } else {
      int start = int.tryParse(_startPeriodController.text) ?? 0;
      int end = int.parse(value);
      if (start >= end) {
        return "End period must be greater than start period";
      }
      return null;
    }
  }

  String? _startPeriodValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Start period cannot be empty";
    } else if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return "Start period must be a positive integer";
    } else {
      int start = int.parse(value);
      int end = int.tryParse(_endPeriodController.text) ?? 0;
      if (start >= end) {
        return "Start period must be less than end period";
      }
      return null;
    }
  }

  void _selectStartTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selecteTime = DateTime.parse("2021-12-23 $hour:$minute:00");

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
        DateTime selecteEndTime = DateTime.parse("2021-12-23 $hour:$minute:00");
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
/////////////
///

class DayDropdown extends StatefulWidget {
  final String labelText;
  final Function(int?) onChanged;
  final int? initialDay;

  const DayDropdown({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.initialDay,
  }) : super(key: key);

  @override
  _DayDropdownState createState() => _DayDropdownState();
}

class _DayDropdownState extends State<DayDropdown> {
  int? _selectedDay;

  // Define the list of days
  List<String> sevendays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    // Define the list of dropdown menu items using sevendays list
    final List<DropdownMenuItem<int>> _dayItems = List.generate(
      sevendays.length,
      (index) => DropdownMenuItem(
        child: Text(sevendays[index]),
        value: index + 1,
      ),
    );

    return DropdownButtonFormField(
      value: _selectedDay,
      items: _dayItems,
      onChanged: (value) {
        setState(() => _selectedDay = value);
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        hintText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
