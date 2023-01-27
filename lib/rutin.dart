// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/addutinScren.dart';
import 'package:table/freash.dart';
import 'package:table/provider/myRutinProvider.dart';

class RutinScreem extends StatelessWidget {
  const RutinScreem({super.key});

  @override
  Widget build(BuildContext context) {
    //
    var myList = Provider.of<MyRutinProvider>(context).MyClass;

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
                        //             roomnum: myList[index]["roomnum"],
                        //             instractorname: myList[index]
                        //                 ["instructorname"],
                        //             subCode: myList[index]["subjectcode"],
                        //             start: myList[index]["startingpriode"],
                        //             end: myList[index]["endingpriode"],
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
                                  myList.length,
                                  (index) => myClassContainer(
                                        roomnum: myList[index]["roomnum"],
                                        instractorname: myList[index]
                                            ["instructorname"],
                                        subCode: myList[index]["subjectcode"],
                                        start: myList[index]["startingpriode"],
                                        end: myList[index]["endingpriode"],
                                        startTime: myList[index]["start_time"],
                                        endTime: myList[index]["end_time"],
                                      )),
                            ),

                            ////
                            ///
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(
                                  // scrollDirection: Axis.vertical,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  myList.length,
                                  (index) => myClassContainer(
                                        roomnum: myList[index]["roomnum"],
                                        instractorname: myList[index]
                                            ["instructorname"],
                                        subCode: myList[index]["subjectcode"],
                                        start: myList[index]["startingpriode"],
                                        end: myList[index]["endingpriode"],
                                        startTime: myList[index]["start_time"],
                                        endTime: myList[index]["end_time"],
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
