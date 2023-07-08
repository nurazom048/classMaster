// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/controller/priode_controller.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/priode_request.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/widgets/select_time.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_buttons.dart';

class AppPriodePage extends StatefulWidget {
  const AppPriodePage({
    Key? key,
    required this.routineId,
    this.routineName,
    required this.totalPriode,
    this.isEdit = false,
    this.priodeId,
  }) : super(key: key);

  final String routineId;
  final String? routineName;
  final int totalPriode;
  final bool isEdit;
  final String? priodeId;

  @override
  State<AppPriodePage> createState() => _AppPriodePageState();
}

class _AppPriodePageState extends State<AppPriodePage> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool showStartTime = false;
  bool showEndTime = false;
  DateTime? st;
  DateTime? et;

  @override
  void initState() {
    super.initState();
    insertEditedValue();
  }

  @override
  Widget build(BuildContext context) {
    int periodNumber = widget.totalPriode == 0 ? 1 : widget.totalPriode + 1;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
              .copyWith(bottom: 0),
          child: Column(
            children: [
              // Header
              HeaderTitle('', context, margin: EdgeInsets.zero),
              Consumer(builder: (context, ref, _) {
                //Provider
                final periodNotifier =
                    ref.watch(priodeController(widget.routineId).notifier);

                final h = MediaQuery.of(context).size.height;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.03),
                    Text(
                        widget.isEdit == true
                            ? "Eddit Priode"
                            : 'Add A New Priode Here',
                        style: TS.heading(fontSize: 39)),
                    SizedBox(height: h * 0.05),
                    Text(
                      'Priode Number $periodNumber',
                      textScaleFactor: 1.5,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectTime(
                          width: 170,
                          timeText: 'Start Time',
                          time: startTime,
                          show: showStartTime,
                          onTap: _selectStartTime,
                        ),
                        SelectTime(
                          width: 170,
                          timeText: 'End Time',
                          time: endTime,
                          show: showEndTime,
                          onTap: _selectEndTime,
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.45),
                    if (widget.isEdit == false)
                      CupertinoButtonCustom(
                          icon: Icons.check,
                          color: AppColor.nokiaBlue,
                          text: "Add Priode",
                          onPressed: () async {
                            setState(() {});

                            //

                            if (st != null && et != null) {
                              periodNotifier.addPriode(
                                ref,
                                context,
                                startTime,
                                endTime,
                              );
                            }

                            //
                          })
                    else
                      CupertinoButtonCustom(
                          icon: Icons.check,
                          text: "Eddit priode",
                          color: AppColor.nokiaBlue,
                          onPressed: () async {
                            print("Ontap to eddit");

                            // setState(() {});
                            if (widget.priodeId != null) {
                              print('inside eddit');
                              periodNotifier.edditPriode(
                                ref,
                                context,
                                widget.priodeId!,
                                startTime,
                                endTime,
                              );
                            }
                            //
                          }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  //

  void _selectStartTime() {
    showTimePicker(
      context: context,
      initialTime: widget.isEdit == true
          ? TimeOfDay(hour: startTime.hour, minute: startTime.minute)
          : TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selectedTime = DateTime.parse("2021-12-23 $hour:$minute:00");

        setState(() {
          showStartTime = true;
          st = selectedTime;
          startTime = selectedTime;
          // startTimeDemo = selectedTime;
          print(startTime.toIso8601String());
        });
      }
    });
  }

  //--- end time
  void _selectEndTime() {
    showTimePicker(
      context: context,
      initialTime: widget.isEdit == true
          ? TimeOfDay(hour: endTime.hour, minute: endTime.minute)
          : TimeOfDay(hour: startTime.hour, minute: startTime.minute),
    ).then((value) {
      if (value != null) {
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selectedEndTime =
            DateTime.parse("2021-12-23 $hour:$minute:00");
        //
        setState(() {
          showEndTime = true;

          et = selectedEndTime;
          endTime = selectedEndTime;
          //endTimDemo = selectedEndTime;
          print(endTime.toIso8601String());
        });
      }
    });
  }

  //
  String getOrdinal(int number) {
    if (number == 1) {
      return "1st";
    } else if (number == 2) {
      return "2nd";
    } else if (number == 3) {
      return "3rd";
    } else if (number >= 4 && number <= 10) {
      return "${number}th";
    } else {
      return "$number";
    }
  }

  void insertEditedValue() async {
    if (widget.isEdit == true) {
      final addRes =
          await PriodeRequest().findPriodesYid(widget.priodeId ?? '');
      print("i am from cont");

      addRes.fold(
        (l) {
          print(l);
          return Alert.errorAlertDialog(context, l);
        },
        (r) {
          startTime = r.startTime;
          endTime = r.endTime;
          showEndTime = true;
          showStartTime = true;
        },
      );

      setState(() {});
    }
  }
}

String endMaker(String test) {
  List<String> words = test.split(' ');
  String lastWord = words.last;

  if (lastWord.endsWith('Z')) {
    return test;
  } else {
    String modifiedLastWord = '${lastWord}Z';
    words[words.length - 1] = modifiedLastWord;
    return words.join(' ');
  }
}
