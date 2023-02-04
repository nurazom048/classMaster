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

class AllClassScreen extends StatefulWidget {
  String rutinId;
  AllClassScreen({super.key, required this.rutinId});

  @override
  State<AllClassScreen> createState() => _RutinScreemState();
}

class _RutinScreemState extends State<AllClassScreen> {
  List<Map<String, dynamic>> classes = [];
  //
  Future allrutin() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.31.229:3000/class/${widget.rutinId}/all/class'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = json.decode(response.body);
        responseMap.forEach((key, value) {
          classes.add({"day": key, "classes": value});
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    var rutin = Provider.of<MyRutinProvider>(context).rutin;
    var priode = Provider.of<TopPriodeProvider>(context).mypriodelist;

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

                      ///\.. show all class
                      FutureBuilder(
                        future: allrutin(),
                        builder: (Context, snapshoot) {
                          if (snapshoot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Waiting");
                          } else {
                            // ignore: avoid_print
                            print(classes);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //.... Weakday list
                              children: List.generate(
                                7,
                                (weakdayIndex) {
                                  return classes[weakdayIndex]["classes"]
                                          .isEmpty // iwnt to retun a emmty text if the lenght is empth
                                      ? const _empty()
                                      : Row(
                                          //   class on this weaK DAY
                                          children: List.generate(
                                              classes[weakdayIndex]["classes"]
                                                  .length, (index) {
                                            return myClassContainer(
                                              roomnum: classes[weakdayIndex]
                                                  ["classes"][index]["room"],

                                              //
                                              instractorname:
                                                  classes[weakdayIndex]
                                                              ["classes"][index]
                                                          ["instuctor_name"] ??
                                                      "",
                                              //

                                              subCode: classes[weakdayIndex]
                                                  ["classes"][index]["room"],

                                              // start end
                                              start: classes[weakdayIndex]
                                                  ["classes"][index]["start"],
                                              end: classes[weakdayIndex]
                                                  ["classes"][index]["end"],

                                              // start time end tyme
                                              startTime: DateTime.parse(
                                                  classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["start_time"]),
                                              endTime: DateTime.parse(
                                                  classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["end_time"]),
                                              //
                                              has_class: classes[weakdayIndex]
                                                      ["classes"][index]
                                                  ["has_class"],

                                              // onTap: () => _onTap_class(
                                              //   context,
                                              //   listofweakday[weakdayIndex]
                                              //       [index]["roomnum"],
                                              //   listofweakday[weakdayIndex]
                                              //       [index]["instructorname"],
                                              //   listofweakday[weakdayIndex]
                                              //       [index]["subjectcode"],
                                              // ),
                                              weakdayIndex: weakdayIndex,
                                              //
                                              onLongPress: () =>
                                                  _onLongpress_class(
                                                context,
                                                "sun",
                                              ),
                                            );
                                          }),
                                        );
                                },
                              ),
                            );
                          }
                        },
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

  Widget emptyreturn(listofweakday, weakdayIndex) {
    if (listofweakday[listofweakday].isEmpty) {
      return Text("empty");
    } else {
      return Text("not empty");
    }
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
