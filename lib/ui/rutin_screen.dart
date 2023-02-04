// ignore_for_file: unused_local_variable, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

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
import 'package:http/http.dart' as http;

class RutinScreem extends StatefulWidget {
  List<Map<String, dynamic>>? allClassList;
  RutinScreem({super.key, this.allClassList});

  @override
  State<RutinScreem> createState() => _RutinScreemState();
}

class _RutinScreemState extends State<RutinScreem> {
  //

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
      sun,
      sun,
      sun,
      sun,
    ];

    // print(widget.allClassList![2]["classes"].length);
    //  ListView.builder(
    //       itemCount: widget.allClassList!.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //               widget.allClassList![index]["classes"].length.toString()),
    //         );
    //       },
    //     ),

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //...... Appbar.......!!
            InkWell(
                onTap: () {
                  // print("ontap");
                  // _getAllClassOfRutin(context);
                  // Future listOfAllClasss = _getAllClassOfRutin();
                  // listOfAllClasss.then((value) {
                  //   setState(() {
                  //     listofweakday = value;
                  //   });
                  // });
                },
                child: _Appbar(context)),

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
                          priode.length,
                          (index) => index == 0
                              ? CornerBox()
                              : PriodeContaner(
                                  startTime: priode[index]["start_time"],
                                  endtime: priode[index]["end_time"],
                                  priode: index,
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
                                    return listofweakday[weakdayIndex].isEmpty
                                        ? const _empty()
                                        : Wrap(
                                            direction: Axis
                                                .horizontal, //   class on this weaK DAY
                                            children: List.generate(
                                                widget
                                                    .allClassList![weakdayIndex]
                                                        ["classes"]
                                                    .length, (index) {
                                              print(widget
                                                  .allClassList![weakdayIndex]
                                                      ["classes"][0]["room"]
                                                  .toString());

                                              return myClassContainer(
                                                roomnum: widget.allClassList![
                                                        weakdayIndex]["classes"]
                                                    [index]["room"],

                                                //
                                                instractorname: widget
                                                            .allClassList![
                                                        weakdayIndex]["classes"]
                                                    [index]["subjectcode"],
                                                //

                                                subCode:
                                                    listofweakday[weakdayIndex]
                                                        [index]["subjectcode"],

                                                // start end
                                                start: widget.allClassList![
                                                        weakdayIndex]["classes"]
                                                    [index]["start"],
                                                end: widget.allClassList![
                                                        weakdayIndex]["classes"]
                                                    [index]["end"],

                                                // start time end tyme
                                                startTime: DateTime.parse(
                                                  widget.allClassList![
                                                              weakdayIndex]
                                                          ["classes"][index]
                                                      ["start_time"],
                                                ),
                                                endTime:
                                                    listofweakday[weakdayIndex]
                                                        [index]["end_time"],

                                                onTap: () => _onTap_class(
                                                  context,
                                                  listofweakday[weakdayIndex]
                                                      [index]["roomnum"],
                                                  listofweakday[weakdayIndex]
                                                      [index]["instructorname"],
                                                  listofweakday[weakdayIndex]
                                                      [index]["subjectcode"],
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

            ///
          ]),
    )));
  }
}

//

//

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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
                  top: BorderSide(color: CupertinoColors.lightBackgroundGray)),
            ),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
