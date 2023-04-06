// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priodeController.dart';
import 'package:table/widgets/MyTextFields.dart';
import 'package:table/widgets/select_time.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AppPriodePage extends StatefulWidget {
  final String rutinId;
  const AppPriodePage({super.key, required this.rutinId});

  @override
  State<AppPriodePage> createState() => _AppPriodePageState();
}

class _AppPriodePageState extends State<AppPriodePage> {
  //
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool show = false;
  final priodeNumController = TextEditingController();

//... Add Priode ...//
  String? message;

  ///
  ///  //.. just for ui
  late DateTime startTimeDemo = DateTime.now();
  late DateTime endTimDemo = DateTime.now();

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
                    MyTextField(
                      name: "Priode Number",
                      keyboardType: TextInputType.number,
                      controller: priodeNumController,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Priode Number is  Required';
                        }
                        return null;
                      },
                    ),

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
                    // const MyText(" Start and end time "),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SelectTime(
                    //       width: 170,
                    //       time_text: "start_time",
                    //       time: startTime,
                    //       show: show,
                    //       onTap: _selectStartTime,
                    //     ),
                    //     SelectTime(
                    //       width: 170,
                    //       time_text: "end time",
                    //       time: endTime,
                    //       show: show,
                    //       onTap: _selectEndTime,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 70),
                    //
                    Consumer(builder: (context, ref, _) {
                      final isLoding = ref.watch(priodeController);

                      return Align(
                        alignment: Alignment.center,
                        child: (isLoding != null && isLoding == true)
                            ? CupertinoButton(
                                onPressed: () {},
                                child: const CircularProgressIndicator())
                            : CupertinoButton(
                                child: Text("Add Priode"),
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(7),
                                onPressed: () {
                                  ref
                                      .watch(priodeController.notifier)
                                      .addPriode(
                                          ref,
                                          context,
                                          startTime,
                                          endTime,
                                          widget.rutinId,
                                          int.parse(priodeNumController.text
                                              .toString()));
                                }),
                      );
                    }),
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
