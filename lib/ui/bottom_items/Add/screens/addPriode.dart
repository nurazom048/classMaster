// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priodeController.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import 'package:table/widgets/heder/hederTitle.dart';
import 'package:table/widgets/select_time.dart';

class AppPriodePage extends StatefulWidget {
  const AppPriodePage(
      {super.key, required this.rutinId, required this.rutinName});
  final String rutinId;
  final String rutinName;
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 300),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle(" ${widget.rutinName}", context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0)
                      .copyWith(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Priode Screen',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          height: 49 / 36,
                          color: Colors.black,
                        ),
                      ),

                      ///

                      //
                      Column(
                        children: List.generate(priodeList.length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(" ${getOrdinal(index)} Priode",
                                  textScaleFactor: 1.5),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            ],
                          );
                        }),
                      ),

                      //

                      Column(
                        children: List.generate(1, (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(" Set New priode time here ",
                                  textScaleFactor: 1.5),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            ],
                          );
                        }),
                      ),

                      //
                    ],
                  ),
                ),

                //
                //  const Spacer(flex: 29),

                const SizedBox(height: 30),
                CupertinoButtonCustom(
                    //  padding: const EdgeInsets.symmetric(horizontal: 150),
                    textt: "Add Priode",
                    onPressed: () async {
                      if (st != null && et != null) {
                        priodeList.add({
                          "start_time": st,
                          "end_time": et,
                          "priode_number":
                              priodeList.isEmpty ? 1 : priodeList.length + 1,
                        });
                        setState(() {});
                        print(priodeList);

                        //
                        ref.watch(priodeController.notifier).addPriode(
                            ref,
                            priodeList[priodeList.length - 1],
                            widget.rutinId,
                            context);

                        //
                      } else {
                        print("null valu");
                      }
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
}

// class AppPriodePage extends StatefulWidget {
//   final String rutinId;
//   const AppPriodePage({super.key, required this.rutinId});

//   @override
//   State<AppPriodePage> createState() => _AppPriodePageState();
// }

// class _AppPriodePageState extends State<AppPriodePage> {
//   //
//   DateTime startTime = DateTime.now();
//   DateTime endTime = DateTime.now();
//   bool show = false;
//   final priodeNumController = TextEditingController();

// //... Add Priode ...//
//   String? message;

//   ///

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Priode'),
//         ),
//         body: CustomScrollView(
//           slivers: [
//             SliverFillRemaining(
//                 child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     MyTextField(
//                       name: "Priode Number",
//                       keyboardType: TextInputType.number,
//                       controller: priodeNumController,
//                       validate: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Priode Number is  Required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const MyText(" Start and end time "),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SelectTime(
//                           width: 170,
//                           time_text: "start_time",
//                           time: startTime,
//                           show: show,
//                           onTap: _selectStartTime,
//                         ),
//                         SelectTime(
//                           width: 170,
//                           time_text: "end time",
//                           time: endTime,
//                           show: show,
//                           onTap: _selectEndTime,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 70),
//                     //
//                     Consumer(builder: (context, ref, _) {
//                       final isLoding = ref.watch(priodeController);

//                       return Align(
//                         alignment: Alignment.center,
//                         child: (isLoding != null && isLoding == true)
//                             ? CupertinoButton(
//                                 onPressed: () {},
//                                 child: const CircularProgressIndicator())
//                             : CupertinoButton(
//                                 child: Text("Add Priode"),
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(7),
//                                 onPressed: () {
//                                   ref
//                                       .watch(priodeController.notifier)
//                                       .addPriode(
//                                           ref,
//                                           context,
//                                           startTime,
//                                           endTime,
//                                           widget.rutinId,
//                                           int.parse(priodeNumController.text
//                                               .toString()));
//                                 }),
//                       );
//                     }),
//                   ]),
//             ))
//           ],
//         ),
//       ),
//     );
//   }

//   //--- start time
