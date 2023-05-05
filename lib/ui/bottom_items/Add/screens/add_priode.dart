// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priodeController.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/priode_request.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:table/widgets/select_time.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';

class AppPriodePage extends StatefulWidget {
  const AppPriodePage({
    super.key,
    required this.rutinId,
    this.rutinName,
    required this.totalpriode,
    this.isEddit = false,
    this.priode_id,
  });
  final String rutinId;
  final String? rutinName;
  final int? totalpriode;
  final bool? isEddit;

  final String? priode_id;
  @override
  State<AppPriodePage> createState() => _AppPriodePageState();
}

class _AppPriodePageState extends State<AppPriodePage> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool show = false;
  DateTime? st;
  DateTime? et;

  List<Map<String, dynamic>> priodeList = [];

  @override
  void initState() {
    super.initState();

    insartEdditedvalu();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rutinId);
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 300),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle(" ${widget.priode_id}", context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0)
                      .copyWith(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const ma.Text(
                        'Add A New \nPriode Here',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          height: 49 / 36,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),

                      Column(
                        children: List.generate(1, (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ma.Text("Priode Number $priodeList  ",
                                  textScaleFactor: 1.5),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SelectTime(
                                    width: 170,
                                    timeText: "start_time",
                                    time: startTime,
                                    show: show,
                                    onTap: _selectStartTime,
                                  ),
                                  SelectTime(
                                    width: 170,
                                    timeText: "end time",
                                    time: endTime,
                                    show: show,
                                    onTap: _selectEndTime,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),

                      //
                    ],
                  ),
                ),

                //

                const SizedBox(height: 30),

                if (widget.isEddit == false)
                  CupertinoButtonCustom(
                      //  padding: const EdgeInsets.symmetric(horizontal: 150),
                      textt: "Add Priode",
                      onPressed: () async {
                        setState(() {});
                        print(priodeList);

                        //

                        if (st != null && et != null) {
                          ref.watch(priodeController.notifier).addPriode(
                              ref, context, widget.rutinId, startTime, endTime);
                        }

                        //
                      })
                else
                  CupertinoButtonCustom(
                      textt: "Eddit priode",
                      onPressed: () async {
                        print("Ontap to eddir");

                        // setState(() {});
                        print(priodeList);
                        if (st != null && et != null) {
                          ref.watch(priodeController.notifier).edditPriode(
                                ref,
                                context,
                                widget.rutinId,
                                widget.priode_id ?? '',
                                startTime,
                                endTime,
                              );
                        }
                        //
                      }),
              ],
            ),
          );
        }),
      ),
    );
  }

  //

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

  void insartEdditedvalu() async {
    if (widget.isEddit == true) {
      var addRes = await PriodeRequest().findPriodebYid(widget.priode_id ?? '');
      print("i am from cont");

      addRes.fold(
        (l) {
          return Alart.errorAlartDilog(context, l);
        },
        (r) {
          startTime = r.startTime;
          endTime = r.endTime;
          show = true;
        },
      );

      setState(() {});
    }
  }
}
