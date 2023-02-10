// ignore_for_file: unused_local_variable, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names, avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/classdetals.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/class_contaner.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/priodeContaner.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';

class AllClassScreen extends StatefulWidget {
  String rutinId;

  AllClassScreen({super.key, required this.rutinId});

  @override
  State<AllClassScreen> createState() => _RutinScreemState();
}

class _RutinScreemState extends State<AllClassScreen> {
  List<Map<String, dynamic>> classes = [];

  String? message;
  //.. get all rutines ...
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

  // chack status
  var opres;
  late bool save;
  Future chackStatus() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse(
              'http://192.168.31.229:3000/rutin/save/${widget.rutinId}/chack'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        opres = res;
        save = res["save"];
        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  //.. get all rutines ...
  Future saverutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse('http://192.168.31.229:3000/rutin/save/${widget.rutinId}'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        save = res["save"];
        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  //..unsve rutin .
  Future unSaveRutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse(
              'http://192.168.31.229:3000/rutin/unsave/${widget.rutinId}'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("RutinId:  ${widget.rutinId}");
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
                CustomTopBar("Kpi 7/1/ET-C",
                    acction: IconButton(
                        onPressed: () {
                          //   chackStatus();
                          //   saverutin();
                          _showModalBottomSheet(context, widget.rutinId);
                        },
                        icon: Icon(Icons.more_vert)), ontap: () {
                  print("ontap");
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) =>
                            AddClass(rutinId: widget.rutinId)),
                  );
                }),

                //.....Priode rows.....//
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          priode.length,
                          (index) => index == 0
                              ? Empty(corner: true)
                              : PriodeContaner(
                                  startTime: priode[index]["start_time"],
                                  endtime: priode[index]["end_time"],
                                  priode: index,
                                ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SevenDaysName(),

                          ///.. show all class
                          FutureBuilder(
                            future: allrutin(),
                            builder: (Context, snapshoot) {
                              if (snapshoot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                // print(classes);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //.... Weakday list
                                  children: List.generate(
                                    7,
                                    (weakdayIndex) {
                                      return classes[weakdayIndex]["classes"]
                                              .isEmpty // iwnt to retun a emmty text if the lenght is empth
                                          ? Empty()
                                          : Row(
                                              //   class on this weaK DAY
                                              children: List.generate(
                                                  classes[weakdayIndex]
                                                          ["classes"]
                                                      .length, (index) {
                                                return ClassContainer(
//
                                                  classname:
                                                      classes[weakdayIndex]
                                                              ["classes"][index]
                                                          ["name"],

                                                  //
                                                  roomnum: classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["room"],

                                                  //
                                                  instractorname: classes[
                                                                  weakdayIndex]
                                                              ["classes"][index]
                                                          ["instuctor_name"] ??
                                                      "",
                                                  //

                                                  subCode: classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["room"],

                                                  // start end
                                                  start: classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["start"],
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
                                                  has_class:
                                                      classes[weakdayIndex]
                                                              ["classes"][index]
                                                          ["has_class"],
                                                  weakday: classes[weakdayIndex]
                                                          ["classes"][index]
                                                      ["weekday"],

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

                                                  //..for  edit or delete
                                                  onLongPress: () {
                                                    print("ontap");

                                                    _onLongpress_class(
                                                      context,
                                                      classes[weakdayIndex]
                                                              ["classes"][index]
                                                          ["_id"],
                                                      message,
                                                    );
                                                  },
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
                ///
                ///
                ///
                ///
                ///
                ///
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Owner Account",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                FutureBuilder(
                    future: chackStatus(),
                    builder: (Context, snapshoot) {
                      if (snapshoot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        // print(" hi the res ");
                        // print(" hi the res ${opres["user"]["username"]}");
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.amber,
                              ),
                              //
                              Spacer(flex: 3),
                              Text.rich(
                                TextSpan(
                                    text: opres["user"]["name"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text:
                                              '\n${opres["user"]["username"]}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ))
                                    ]),
                              ),
                              Spacer(flex: 40),
                            ],
                          ),
                        );
                      }
                    })
              ]),

          //
        ),
      ),
    );
  }
//

  void _showModalBottomSheet(BuildContext context, id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.grey[200],
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  opres["isOwner"] == true
                      ? ListTile(
                          leading: Icon(Icons.edit),
                          title: Text("Edit",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AddClass(rutinId: widget.rutinId)),
                            );
                          })
                      : Container(),
                  ListTile(
                      leading: Icon(Icons.save),
                      title: Text(save == false ? "Saved" : " unsave",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () async {
                        print("ontap");
                        print("save:$save");
                        save == true ? unSaveRutin() : saverutin();
                      }),
                  opres["isOwner"] == true
                      ? ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text("Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          onTap: () {})
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}

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
_onLongpress_class(context, classId, message) {
  //,, delete class
  Future<void> deleteClass() async {
    // print(classId);

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.delete(
        Uri.parse('http://192.168.31.229:3000/class/delete/$classId'),
        headers: {'Authorization': 'Bearer $getToken'});

    //.. show message
    final res = json.decode(response.body);
    message = json.decode(response.body)["message"];
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message!)));
    }
    //
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

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
                      color: Colors.black))),

          BottomText(
            "Edit",
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddClass(
                        rutinId: "rutinId",
                        classId: classId,
                        isEdit: true,
                      )),
            ),
          ),

          //.... remove
          BottomText(
            "Remove",
            color: CupertinoColors.destructiveRed,
            onPressed: () => deleteClass(),
          ),
          //.... Cancel
          BottomText("Cancel"),
        ],
      ),
    ),
  );
}
