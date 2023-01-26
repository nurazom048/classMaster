// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
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
            MyText(" Start and end time"),
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
                        onTap: () {
                          // your callback here
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                      hintText: "Start Time",
                    ),
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
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                      hintText: "End Time",
                    ),
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
                onPressed: () {},
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7),
              ),
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
