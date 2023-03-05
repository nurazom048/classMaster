// ignore_for_file: sort_child_properties_last, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable, unnecessary_string_interpolations, sized_box_for_whitespace
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/MyTextFields.dart';
import 'package:table/widgets/select_time.dart';
import '../../widgets/text and buttons/mytext.dart';

class AddClass extends StatefulWidget {
  String rutinId;
  String? classId;
  bool? isEdit;
  AddClass({
    super.key,
    required this.rutinId,
    this.classId,
    this.isEdit,
  });

  @override
  State<AddClass> createState() => _AddClassState();
}

//
final _className = TextEditingController();
final _instructorController = TextEditingController();
final _roomController = TextEditingController();
final _subCodeController = TextEditingController();
final _startPeriodController = TextEditingController();
final _endPeriodController = TextEditingController();

class _AddClassState extends State<AddClass> {
  final fromKey = GlobalKey<FormState>();

  late DateTime startTime;
  late DateTime endTime;
  bool show = false;
  int _selectedDay = 1;
  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimDemo = DateTime.now();

  String base = "192.168.0.125:3000";
  // String base = "192.168.31.229:3000";

  var message;
  // Add class

  Future<void> addClass(context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('http://$base/class/${widget.rutinId}/addclass/'),
        body: {
          "name": _className.text,
          "instuctor_name": _instructorController.text,
          "room": _roomController.text,
          "subjectcode": _subCodeController.text,
          "start": _startPeriodController.text,
          "end": _endPeriodController.text,
          "has_class": "has_class",
          "weekday": _selectedDay.toString(),
          "start_time": "${startTime.toIso8601String()}Z",
          "end_time": "${endTime.toIso8601String()}Z",
        },
        headers: {
          'Authorization': 'Bearer $getToken'
        });
    message = json.decode(response.body)["message"];
    print(message);

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body);
      Navigator.pop(context);

      //print response
      print("rutin created successfully");
      print(res);
    } else {
      Alart.errorAlartDilog(context, message);
    }
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

// Add class

  Future<void> editClass(context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http
        .post(Uri.parse('http://$base/class/eddit/${widget.classId}'), body: {
      "name": _className.text,
      "instuctor_name": _instructorController.text,
      "room": _roomController.text,
      "subjectcode": _subCodeController.text,
      "start": _startPeriodController.text,
      "end": _endPeriodController.text,
      "has_class": "has_class",
      "weekday": _selectedDay.toString(),
      "start_time": "${startTime.toIso8601String()}",
      "end_time": "${endTime.toIso8601String()}",
    }, headers: {
      'Authorization': 'Bearer $getToken'
    });
    message = json.decode(response.body)["message"];
    print(message);

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body);
      Navigator.pop(context);

      //print response
      print("rutin created successfully");
      print(res);
    } else {
      throw Exception('Failed to load data');
    }
  }

// find class
  Future<void> findClass() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.get(
        Uri.parse('http://$base/class/find/class/${widget.classId}'),
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
        startTime =
            DateTime.parse(json.decode(response.body)["classs"]["start_time"]);
        endTime =
            DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

        //
        startTimeDemo =
            DateTime.parse(json.decode(response.body)["classs"]["start_time"]);
        endTimDemo =
            DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

        show = true;

        //
        _startPeriodController.text =
            json.decode(response.body)["classs"]["start"].toString();
        _endPeriodController.text =
            json.decode(response.body)["classs"]["end"].toString();
      });

      // print("${s.runtimeType}   vhey");
    } else {
      Alart.errorAlartDilog(context, message);
      throw Exception('Failed to load data');
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
      appBar: AppBar(title: Text(sevendays[_selectedDay - 1].toString())),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            ///...Class name
            MyTextField(
              name: "Class name",
              controller: _className,
            ),

            ///...Instructor name
            MyTextField(
              name: "Instructor namer",
              controller: _instructorController,
            ),

            ///.... room number
            MyTextField(
              name: "room number",
              controller: _roomController,
            ),
            MyTextField(
              name: "sub_code",
              controller: _subCodeController,
            ),

            //

            MyText(" Start and end time "),

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

            // //

            MyText(" Start and end Priode"),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                        hintText: "Start priode",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "End period cannot be empty";
                        } else {
                          return "";
                        }
                      }),
                ),
                Container(
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
                      hintText: "End priode",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "End period cannot be empty";
                      } else {
                        return "";
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //.............. Submit botton ..............//

            Align(
              alignment: Alignment.center,
              child: CupertinoButton(
                  child: Text(widget.isEdit == true ? "Eddit" : "Submit"),
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7),
                  onPressed: () {
                    print("ontap submit btn");
                    widget.isEdit == true
                        ? editClass(context)
                        : addClass(context);
                    if (message != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message!)));
                    }
                    // final isvalidfrom = fromKey.currentState!.validate();
                    // if (isvalidfrom) {

                    // }
                  }),
            ),
          ],
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
