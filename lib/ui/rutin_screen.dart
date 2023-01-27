// ignore_for_file: unused_local_variable, unnecessary_null_comparison, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/classdetals.dart';
import 'package:table/old/freash.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/widgets/class_contaner.dart';
import 'package:table/ui/widgets/days_container.dart';
import 'package:table/ui/widgets/priodeContaner.dart';

class RutinScreem extends StatelessWidget {
  const RutinScreem({super.key});

  @override
  Widget build(BuildContext context) {
    var Sunday = Provider.of<MyRutinProvider>(context).rutin["Sunday"];
    var mypriodelist = Provider.of<TopPriodeProvider>(context).mypriodelist;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...... Appbar.......!!
                CustomTopBar("Kpi 7/1/ET-C",
                    ontap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AddClass(
                                    dayname: "",
                                  )),
                        )),

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
                                  // scrollDirection: Axis.vertical,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  mypriodelist.length,
                                  (index) => PriodeContaner(
                                        startTime: mypriodelist[index]
                                            ["start_time"],
                                        endtime: mypriodelist[index]
                                            ["end_time"],
                                        priode: index,
                                      ))),
                          /////////////////////////////////////////////////////////////////////////////////////////
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            direction: Axis.vertical,
                            children: List.generate(
                                7,
                                (indexofdate) => DaysContaner(
                                      indexofdate: indexofdate,
                                    )),
                          ),
                          //

                          Column(
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                children: List.generate(
                                  Sunday!.length,
                                  (index) => myClassContainer(
                                    roomnum: Sunday[index]["roomnum"],
                                    instractorname: Sunday[index]
                                        ["instructorname"],
                                    subCode: Sunday[index]["subjectcode"],
                                    start: Sunday[index]["startingpriode"],
                                    end: Sunday[index]["endingpriode"],
                                    startTime: Sunday[index]["start_time"],
                                    endTime: Sunday[index]["end_time"],

                                    onTap: () => _onTap_class(
                                      context,
                                      Sunday[index]["roomnum"],
                                      Sunday[index]["instructorname"],
                                      Sunday[index]["subjectcode"],
                                    ),
                                    //
                                    onLongPress: () =>
                                        _onLongpress_class(context, "Sunday"),
                                  ),
                                ),
                              ),
                              //
                              Wrap(
                                direction: Axis.horizontal,
                                children: List.generate(
                                    Sunday.length,
                                    (index) => myClassContainer(
                                          roomnum: Sunday[index]["roomnum"],
                                          instractorname: Sunday[index]
                                              ["instructorname"],
                                          subCode: Sunday[index]["subjectcode"],
                                          start: Sunday[index]
                                              ["startingpriode"],
                                          end: Sunday[index]["endingpriode"],
                                          startTime: Sunday[index]
                                              ["start_time"],
                                          endTime: Sunday[index]["end_time"],
                                        )),
                              ),
                            ],
                          )
                        ],
                      ),
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
}
