import 'package:flutter/material.dart';
import 'package:table/main.dart';
import 'package:table/moidels.dart';

class MyWidget extends StatelessWidget {
  //ignore: prefer_const_constructors_in_immutables
  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Saturday",
    ];

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TopContaner(
                      priode: 'Priode',
                      startTime: "sevendays",
                      endtime: "Time"),
                  Wrap(
                    direction: Axis.vertical,
                    children: List.generate(
                      sevendays.length,
                      (index) => Container(
                        decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? const Color.fromRGBO(207, 213, 234, 1)
                                : Colors.black12,
                            border: const Border(
                                right:
                                    BorderSide(color: Colors.black, width: 1))),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(sevendays[index]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                    7,
                    (index) => TopContaner(
                      priode: "${index + 1}",
                      startTime: "8:00",
                      endtime: "8:45",
                    ),
                  ),
                ),

////////////////////////////// class data

                Wrap(
                  direction: Axis.vertical,
                  children: List.generate(
                    classdata.length,
                    ((classindex) => Wrap(
                          direction: Axis.horizontal,
                          children: List.generate(
                            classdata[classindex].date.length,
                            (index) => Container(
                              decoration: BoxDecoration(
                                  color: classindex % 2 == 0
                                      ? const Color.fromRGBO(207, 213, 234, 1)
                                      : Colors.black12,
                                  border: const Border(
                                      right: BorderSide(
                                          color: Colors.black, width: 1))),
                              height: 100,
                              width: (((classdata[classindex]
                                              .date[index]
                                              .endingpriode) -
                                          (classdata[classindex]
                                              .date[index]
                                              .startingpriode)) >
                                      0
                                  ? 100 *
                                      ((classdata[classindex]
                                                  .date[index]
                                                  .endingpriode -
                                              classdata[classindex]
                                                  .date[index]
                                                  .startingpriode) +
                                          1)
                                  : 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(classdata[classindex]
                                      .date[index]
                                      .instructorname),
                                  Text(classdata[classindex]
                                      .date[index]
                                      .subjectcode),
                                  Text(classdata[classindex]
                                      .date[index]
                                      .roomnum),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
