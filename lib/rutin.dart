import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/addutinScren.dart';
import 'package:table/freash.dart';

class RutinScreem extends StatefulWidget {
  const RutinScreem({super.key});

  @override
  State<RutinScreem> createState() => _RutinScreemState();
}

class _RutinScreemState extends State<RutinScreem> {
  List<Map<String, dynamic>> mylisst = [
    {
      "instructorname": " Mrx ",
      "subjectcode": "d",
      "roomnum": "roomnum",
      "startingpriode": 1.0,
      "endingpriode": 3.0,
      "start_time": DateTime(2022, 09, 03, 8, 40),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "instructorname": " Mrx ",
      "subjectcode": "d",
      "roomnum": "roomnum",
      "startingpriode": 1.0,
      "endingpriode": 1.0,
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "instructorname": " Mrx ",
      "subjectcode": "d",
      "roomnum": "roomnum",
      "startingpriode": 1.0,
      "endingpriode": 3.0,
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //...... Appbar.......!!
              CustomTopBar("Kpi 7/1/ET-C",
                  ontap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => AddScreen()),
                      )),

              //.....
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Wrap(
                        //   direction: Axis.vertical,
                        //   children: List.generate(
                        //       // scrollDirection: Axis.vertical,
                        //       // physics: const NeverScrollableScrollPhysics(),
                        //       2,
                        //       (index) => myClassContainer(
                        //             roomnum: mylisst[index]["roomnum"],
                        //             instractorname: mylisst[index]
                        //                 ["instructorname"],
                        //             subCode: mylisst[index]["subjectcode"],
                        //             start: mylisst[index]["startingpriode"],
                        //             end: mylisst[index]["endingpriode"],
                        //           )),
                        // ),
                        /////////////////////////////////////////////////////////////////////////////////////////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(
                                  // scrollDirection: Axis.vertical,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  mylisst.length,
                                  (index) => myClassContainer(
                                        roomnum: mylisst[index]["roomnum"],
                                        instractorname: mylisst[index]
                                            ["instructorname"],
                                        subCode: mylisst[index]["subjectcode"],
                                        start: mylisst[index]["startingpriode"],
                                        end: mylisst[index]["endingpriode"],
                                        startTime: mylisst[index]["start_time"],
                                        endTime: mylisst[index]["end_time"],
                                      )),
                            ),

                            ////
                            ///
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(
                                  // scrollDirection: Axis.vertical,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  2,
                                  (index) => myClassContainer(
                                        roomnum: mylisst[index]["roomnum"],
                                        instractorname: mylisst[index]
                                            ["instructorname"],
                                        subCode: mylisst[index]["subjectcode"],
                                        start: mylisst[index]["startingpriode"],
                                        end: mylisst[index]["endingpriode"],
                                        startTime: mylisst[index]["start_time"],
                                        endTime: mylisst[index]["end_time"],
                                      )),
                            ),
                          ],
                        )

                        ///
                        ///
                        ///
                        ///
                      ],
                    ),
                  ],
                ),
              ),

              //

              //
            ]),
      ),
    );
  }
}

class myClassContainer extends StatelessWidget {
  String instractorname, roomnum, subCode;
  double start, end;
  DateTime startTime, endTime;
  myClassContainer({
    Key? key,
    required this.instractorname,
    required this.roomnum,
    required this.subCode,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double contanerwith = 100;

    if (end - start > 1 && end - start != 0 && end - start > 0) {
      contanerwith = (end - start) * 100;
// do something
    }
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), color: Colors.blueGrey),
          height: 150,
          width: contanerwith,
          child: Column(
            children: [
              _running(),
              Spacer(),
              /////
              Column(
                children: [
                  Text(instractorname),
                  Text(roomnum),
                  Text(subCode),
                  Text(startTime.hour.toString()),
                  Text(endTime.minute.toString()),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Row _running() {
    return Row(
      children: const [
        SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.red,
          radius: 4,
        ),
        Text("   Running"),
        Spacer(flex: 7),
      ],
    );
  }
}
