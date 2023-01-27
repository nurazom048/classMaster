// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl/flutter_intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/rutin.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

//
final _instructorController = TextEditingController();
final _roomController = TextEditingController();
final _subCodeController = TextEditingController();
final _startTimeController = TextEditingController();
final _endTimeController = TextEditingController();
final _startPeriodController = TextEditingController();
final _endPeriodController = TextEditingController();

class _AddScreenState extends State<AddScreen> {
  //

  DateTime startTime = DateTime(2022, 01, 01);
  DateTime endTime = DateTime(2022, 01, 01);

  bool show = false;

  double startpriode = 1.0;

  double endpriode = 1.0;

  //
  void addNewClass() {
    Map<String, dynamic> newclass = {
      "instructorname": _instructorController.text,
      "subjectcode": _startTimeController.text,
      "roomnum": _roomController.text,
      "startingpriode": startpriode,
      "endingpriode": startpriode,
      "start_time": startTime,
      "end_time": endTime,
    };
    var myList =
        Provider.of<MyRutinProvider>(context, listen: false).addclass(newclass);

    //  Navigator.pop(context);
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    var myList = Provider.of<MyRutinProvider>(context).MyClass;

    // print(now.weekday);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            MyText("  Start and end time "),
            // Text(DateFormat.EEEE().format(now).toString()),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startTimeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        suffixIcon: InkWell(
                            onTap: () => showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      show = true;
                                      startTime = DateTime(2023, 01, 01,
                                              value.hour, value.minute)
                                          .add(const Duration(days: 0));
                                    });
                                  }
                                }),
                            child: const Icon(Icons.calendar_today)),
                        hintText: show
                            ? DateFormat.jm().format(startTime)
                            : " Start Time"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _endTimeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          // your callback here
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                      hour: startTime.hour,
                                      minute: startTime.minute))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                show = true;

                                endTime = DateTime(
                                        2022, 01, 02, value.hour, value.minute)
                                    .add(const Duration(days: 0));
                              });
                            }
                          });
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                      hintText:
                          show ? DateFormat.jm().format(endTime) : "End Time",
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.runtimeType == "srting") {
                        return "Please enter a valid number";
                      }
                    },
                  ),
                ),
              ],
            ),

            //

            MyText(" Start and end Priode"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                      if (double.tryParse(value!) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
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
                  ),
                ),
              ],
            ),

//..............
            const Spacer(flex: 3),
            Align(
              alignment: Alignment.center,
              child: CupertinoButton(
                child: const Text("Submit"),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7),
                onPressed: addNewClass,
              ),
            ),

            Wrap(
              direction: Axis.horizontal,
              children: List.generate(
                  // scrollDirection: Axis.vertical,
                  // physics: const NeverScrollableScrollPhysics(),
                  myList.length,
                  (index) => myClassContainer(
                        roomnum: myList[index]["roomnum"],
                        instractorname: myList[index]["instructorname"],
                        subCode: myList[index]["subjectcode"],
                        start: myList[index]["startingpriode"],
                        end: myList[index]["endingpriode"],
                        startTime: myList[index]["start_time"],
                        endTime: myList[index]["end_time"],
                      )),
            ),
            const Spacer(flex: 17),
          ],
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  String text;
  MyText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Roboto')),
    );
  }
}
