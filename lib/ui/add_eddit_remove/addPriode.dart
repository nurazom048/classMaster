// ignore_for_file: unused_element, unrelated_type_equality_checks

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/widgets/class_contaner.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';

class AddPriodePage extends StatefulWidget {
  const AddPriodePage({super.key});

  @override
  State<AddPriodePage> createState() => _AddPriodePageState();
}

//

final _startTimeController = TextEditingController();
final _endTimeController = TextEditingController();

class _AddPriodePageState extends State<AddPriodePage> {
  //

  DateTime startTime = DateTime(2022, 01, 01);
  DateTime endTime = DateTime(2022, 01, 01);
  bool show = false;

  //
  void addNewClass() {
    Map<String, dynamic> newPriode = {
      "start_time": startTime,
      "end_time": endTime,
    };
    var mypriodelist = Provider.of<TopPriodeProvider>(context, listen: false)
        .addpriode(newPriode);

    //  Navigator.pop(context);
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    var myList = Provider.of<TopPriodeProvider>(context).mypriodelist;

    // print(now.weekday);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//
            MyText("  Start and end time "),
            // Text(DateFormat.EEEE().format(now).toString()),
            Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () => showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          show = true;
                          startTime =
                              DateTime(2023, 01, 01, value.hour, value.minute)
                                  .add(const Duration(days: 0));
                        });
                      }
                    }),
                    child: Text(
                      show
                          ? DateFormat.jm().format(startTime)
                          : "Start Time yyy",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )),
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

//..............
            const Spacer(flex: 3),
            Align(
              alignment: Alignment.center,
              child: CupertinoButton(
                child: Text("Submit"),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7),
                onPressed: addNewClass,
              ),
            ),

            const Spacer(flex: 17),
          ],
        ),
      ),
    );
  }
}
