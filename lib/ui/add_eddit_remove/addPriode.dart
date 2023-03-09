// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/select_time.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AppPriodePage extends StatefulWidget {
  String rutinId;
  bool? isEddit = false;
  AppPriodePage({super.key, required this.rutinId, this.isEddit});

  @override
  State<AppPriodePage> createState() => _AppPriodePageState();
}

class _AppPriodePageState extends State<AppPriodePage> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool show = false;

//... Add Priode ...//
  String? message;
  Future<void> addPriode(context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/add_priode/${widget.rutinId}'),
          body: {
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
        Alart.errorAlartDilog(context, message!);
      }
    } catch (e) {
      Alart.handleError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Priode'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(" Start and end time "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectTime(
                          width: 170,
                          time_text: "start_time",
                          time: startTime,
                          show: show,
                          onTap: _selectStartTime,
                        ),
                        SelectTime(
                          width: 170,
                          time_text: "end time",
                          time: endTime,
                          show: show,
                          onTap: _selectEndTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    //
                    Align(
                      alignment: Alignment.center,
                      child: CupertinoButton(
                          child: Text("Eddit"),
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(7),
                          onPressed: () {
                            addPriode(context);
                          }),
                    ),
                  ]),
            ))
          ],
        ),
      ),
    );
  }

  //--- start time

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
          // startTimeDemo = selecteTime;
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
          //endTimDemo = selecteEndTime;
          print(endTime.toIso8601String());
        });
      }
    });
  }
}
