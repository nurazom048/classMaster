// ignore_for_file: unused_local_variable, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/classdetals.dart';
import 'package:table/old/freash.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/ui/widgets/class_contaner.dart';
import 'package:table/ui/widgets/corner_box.dart';
import 'package:table/ui/widgets/days_container.dart';
import 'package:table/ui/widgets/priodeContaner.dart';

class RutinScreem extends StatelessWidget {
  const RutinScreem({super.key});

  @override
  Widget build(BuildContext context) {
    var rutin = Provider.of<MyRutinProvider>(context).rutin;
    var priode = Provider.of<TopPriodeProvider>(context).mypriodelist;

    List<Map<String, dynamic>> sun =
        rutin["classs"]!.where((item) => item["weakday"] == 1).toList();

    List<Map<String, dynamic>> mon =
        rutin["classs"]!.where((item) => item["weakday"] == 3).toList();
    List<Map<String, dynamic>> tu =
        rutin["classs"]!.where((item) => item["weakday"] == 3).toList();

    var listofweakday = [
      mon,
      mon.length == 0
          ? [
              {
                "instructorname": " dummy",
                "subjectcode": "d",
                "roomnum": "1112",
                "startingpriode": 1,
                "endingpriode": 3.0,
                "start_time": DateTime(2022, 09, 03, 8, 40),
                "end_time": DateTime(2022, 09, 03, 9, 30),
                "weakday": 1
              }
            ]
          : sun,
      sun,
      sun,
      sun,
      sun,
      sun,
    ];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...... Appbar.......!!
                _Appbar(context),

                //.....Priode rows.....//
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            children: List.generate(
                              priode.length + 1,
                              (index) => index == 0
                                  ? const CornerBox()
                                  : PriodeContaner(
                                      startTime: priode[index - 1]
                                          ["start_time"],
                                      endtime: priode[index - 1]["end_time"],
                                      priode: index - 1,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SevenDaysName(),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Wrap(
                                    direction: Axis.vertical,
                                    children: List.generate(
                                      listofweakday.length, //.... Weakday list
                                      (weakdayIndex) {
                                        return listofweakday[weakdayIndex]
                                                .isEmpty
                                            ? const _empty()
                                            : Wrap(
                                                direction: Axis
                                                    .horizontal, //   class on this weaK DAY
                                                children: List.generate(
                                                    listofweakday[weakdayIndex]
                                                        .length, (index) {
                                                  return myClassContainer(
                                                    roomnum: listofweakday[
                                                            weakdayIndex][index]
                                                        ["roomnum"],
                                                    instractorname: sun[index]
                                                        ["subjectcode"],

                                                    subCode: listofweakday[
                                                            weakdayIndex][index]
                                                        ["subjectcode"],
                                                    start: listofweakday[
                                                            weakdayIndex][index]
                                                        ["startingpriode"],
                                                    end: listofweakday[
                                                            weakdayIndex][index]
                                                        ["endingpriode"],
                                                    startTime: listofweakday[
                                                            weakdayIndex][index]
                                                        ["start_time"],
                                                    endTime: listofweakday[
                                                            weakdayIndex][index]
                                                        ["end_time"],

                                                    onTap: () => _onTap_class(
                                                      context,
                                                      listofweakday[
                                                              weakdayIndex]
                                                          [index]["roomnum"],
                                                      listofweakday[
                                                                  weakdayIndex]
                                                              [index]
                                                          ["instructorname"],
                                                      listofweakday[
                                                                  weakdayIndex]
                                                              [index]
                                                          ["subjectcode"],
                                                    ),
                                                    weakdayIndex: weakdayIndex,
                                                    //
                                                    onLongPress: () =>
                                                        _onLongpress_class(
                                                            context, "sun"),
                                                  );
                                                }),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //

                //
              ]),
        ),
      ),
    );
  }

  Widget _SevenDaysName() {
    return Column(
      children: [
        Wrap(
          direction: Axis.vertical,
          children: List.generate(
              7,
              (indexofdate) => DaysContaner(
                    indexofdate: indexofdate,
                  )),
        ),
      ],
    );
  }

  CustomTopBar _Appbar(BuildContext context) {
    return CustomTopBar("Kpi 7/1/ET-C",
        ontap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddClass(
                        dayname: "",
                      )),
            ));
  }

  _onTap_class(context, roomnumber, instructorname, sunjectcode) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => Classdetails(
                roomnumber: roomnumber.toString(),
                instructorname: instructorname.toString(),
                sunjectcode: sunjectcode.toString(),
              )),
    );
  }

  ///.... onlong press
  _onLongpress_class(context, String dayname) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Do you want to..",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black)),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: CupertinoColors.lightBackgroundGray))),
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: const Text("Edit",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.activeBlue)),
                onPressed: () {
                  // go to edit
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EditPage(
                  //             isedit: true,
                  //         ),
                  //     ),
                  // );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    top:
                        BorderSide(color: CupertinoColors.lightBackgroundGray)),
              ),
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: const Text("Remove",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.destructiveRed)),
                onPressed: () {
                  // rutinprovider.removeclass(indexofdate, index);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: CupertinoColors.lightBackgroundGray))),
              child: CupertinoButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: const Text("Cancel",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.activeBlue)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _zero() {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(68, 114, 196, 40),
          border: Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            const Text("Priode"),
            const Divider(color: Colors.black87, height: 10, thickness: .5),
            Column(
              children: const [
                Text("Priode"),
                Text("Days"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _empty extends StatelessWidget {
  const _empty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: 200,
      child: Center(
        child: Text("No Class yeat "),
      ),
    );
  }
}
