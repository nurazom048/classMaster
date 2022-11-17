import 'package:flutter/material.dart';
import 'package:table/classdetals.dart';
import 'package:table/main.dart';

import 'moidels.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // List<String> sevenlist = ["sat", "A", "b", "b", "b", "b"];
    //List<String> sevenlist2 = ["sat", "A", "b", "b", "c"];
    List<Classmodel> facksevenlist = [
      Classmodel(
          instructorname: "Monday",
          subjectcode: "subjectcode",
          mainpic: "mainpic",
          classsumary: "classsumary",
          roomnum: "roomnum"),
    ];

    //

    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopContaner(
                      priode: 'Priode',
                      startTime: "sevendays",
                      endtime: "Time"),
                  Wrap(
                    //direction: Axis.horizontal,
                    children: List.generate(
                      5,
                      (index) => TopContaner(
                        priode: "${index + 1}",
                        startTime: "8:00",
                        endtime: "8:45",
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                  sunday.length - 1,
                  (index) => InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Classdetails(
                                instractorname: '',
                                subjectcode: '',
                                classsumary: '',
                                roomnum: '',
                              )),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: sunday[index + 1 > sunday.length - 1
                                          ? 0
                                          : index + 1]
                                      .subjectcode ==
                                  sunday[index].subjectcode
                              ? Colors.amber
                              : Colors.black12,
                          border: Border(
                              right: BorderSide(
                                  color: sunday[index + 1 > sunday.length - 1
                                                  ? 0
                                                  : index + 1]
                                              .subjectcode ==
                                          sunday[index].subjectcode
                                      ? Colors.amber
                                      : Colors.black12,
                                  width: 1))),
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sunday[index + 1 > index.bitLength
                                            ? index.bitLength
                                            : index + 1]
                                        .subjectcode ==
                                    sunday[index].subjectcode
                                ? "Same\n  ${sunday[index].instructorname}"
                                : sunday[index].instructorname,
                          ),
                          // index == 0
                          //     ? const Text("")
                          //     : Text("subjectcode".toString()),
                          // index == 0
                          //     ? const Text("")
                          //     : Text("roomnum".toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

/////
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                  Mobday.length,
                  (index) => Container(
                    decoration: const BoxDecoration(
                        color: Colors.black12,
                        border: Border(
                            right: BorderSide(color: Colors.black, width: 1))),
                    height: 100,
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Mobday[index].instructorname),
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }
}
