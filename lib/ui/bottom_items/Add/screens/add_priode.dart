// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priode_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/priode_request.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/select_time.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';

class AppPriodePage extends StatefulWidget {
  const AppPriodePage({
    Key? key,
    required this.rutinId,
    this.rutinName,
    required this.totalPriode,
    this.isEdit = false,
    this.priodeId,
  }) : super(key: key);

  final String rutinId;
  final String? rutinName;
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
    insartEditedValue();
  }

  @override
  Widget build(BuildContext context) {
    int periodNumber = widget.totalPriode == 0 ? 1 : widget.totalPriode + 1;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
              .copyWith(bottom: 0),
          child: Column(
            children: [
              // Header
              HeaderTitle('', context, margin: EdgeInsets.zero),
              Consumer(builder: (context, ref, _) {
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
                    SizedBox(height: h * 0.5),
                    if (widget.isEdit == false)
                      CupertinoButtonCustom(
                          color: AppColor.nokiaBlue,
                          textt: "Add Priode",
                          onPressed: () async {
                            setState(() {});

                            //

                            if (st != null && et != null) {
                              ref.watch(priodeController.notifier).addPriode(
                                  ref,
                                  context,
                                  widget.rutinId,
                                  startTime,
                                  endTime);
                            }

                            //
                          })
                    else
                      CupertinoButtonCustom(
                          textt: "Eddit priode",
                          color: AppColor.nokiaBlue,
                          onPressed: () async {
                            print("Ontap to eddir");

                            // setState(() {});
                            if (widget.priodeId != null) {
                              print('inside eddit');
                              ref.watch(priodeController.notifier).edditPriode(
                                    ref,
                                    context,
                                    widget.rutinId,
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
        DateTime selecteTime = DateTime.parse("2021-12-23 $hour:$minute:00");

        setState(() {
          showStartTime = true;
          st = selecteTime;
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
      initialTime: widget.isEdit == true
          ? TimeOfDay(hour: endTime.hour, minute: endTime.minute)
          : TimeOfDay(hour: startTime.hour, minute: startTime.minute),
    ).then((value) {
      if (value != null) {
        String hour = "${value.hour < 10 ? '0' : ''}${value.hour}";
        String minute = "${value.minute < 10 ? '0' : ''}${value.minute}";
        DateTime selecteEndTime = DateTime.parse("2021-12-23 $hour:$minute:00");
        //
        setState(() {
          showEndTime = true;

          et = selecteEndTime;
          endTime = selecteEndTime;
          //endTimDemo = selecteEndTime;
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

  void insartEditedValue() async {
    if (widget.isEdit == true) {
      var addRes = await PriodeRequest().findPriodebYid(widget.priodeId ?? '');
      print("i am from cont");

      addRes.fold(
        (l) {
          return Alart.errorAlartDilog(context, l);
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
