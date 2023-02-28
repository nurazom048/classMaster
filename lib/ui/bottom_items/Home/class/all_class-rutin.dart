// ignore_for_file: unused_local_variable, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names, avoid_print, prefer_const_constructors

import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/provider/topTimeProvider.dart';
import 'package:table/ui/add_eddit_remove/addPriode.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Account/Account_screen.dart';
import 'package:table/ui/bottom_items/Home/class/sunnary/summary_screen.dart';
import 'package:table/ui/classdetals.dart';
import 'package:table/provider/myRutinProvider.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/class_contaner.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/priodeContaner.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';

class AllClassScreen extends StatefulWidget {
  String rutinId;
  String rutinName;
  AllClassScreen({super.key, required this.rutinId, required this.rutinName});

  @override
  State<AllClassScreen> createState() => _RutinScreemState();
}

class _RutinScreemState extends State<AllClassScreen> {
  ///

  String? message;
  //
  //String base = "192.168.0.125:3000";
  String base = "192.168.31.229:3000";

  // chack status
  var opres;
  late bool save;
  Future chackStatus() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse('http://$base/rutin/save/:${widget.rutinId}/chack'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        opres = res;
        save = res["save"];
        //  print(res);
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
          Uri.parse('http://$base/rutin/unsave/:${widget.rutinId}'),
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

  late AccountModels owener;
  @override
  Widget build(BuildContext context) {
    print("RutinId:  ${widget.rutinId}");

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...... Appbar.......!!
                CustomTopBar(widget.rutinName,
                    acction: IconButton(
                        onPressed: () =>
                            _showModalBottomSheet(context, widget.rutinId),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListOfWeakdays(),

                          ///.. show all class
                          FutureBuilder(
                            future: Rutin_Req().rutins_class_and_priode(
                                context, widget.rutinId),
                            builder: (Context, snapshoot) {
                              if (snapshoot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                var Classss = snapshoot.data!.classes;
                                var Priodes = snapshoot.data!.priodes;

                                print("hi i am owender");

                                //.... Priopdes and Classes....//
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListOfPriodes(Priodes, widget.rutinId),

                                      //
                                      ListOfDays(Classss.sunday),
                                      ListOfDays(Classss.monday),
                                      ListOfDays(Classss.thursday),
                                      ListOfDays(Classss.wednesday),
                                      ListOfDays(Classss.thursday),
                                      ListOfDays(Classss.friday),
                                      ListOfDays(Classss.saturday),
                                    ]);
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
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(
                        accountId: opres["user"]["_id"],
                        // rutinName: seach_result[index]["name"],
                        // rutinId: seach_result[index]["_id"],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Owner Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black)),
                  ),
                ),
                FutureBuilder(
                    future: Rutin_Req()
                        .rutins_class_and_priode(context, widget.rutinId),
                    builder: (Context, snapshoot) {
                      if (snapshoot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        AccountModels owener = snapshoot.data!.owener;
                        // print(" hi the res ");
                        // print(" hi the res ${opres["user"]["username"]}");
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountScreen(
                                Others_Account: true,
                                accountUsername: owener.username,
                              ),
                            ),
                          ),
                          child: Container(
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
                                  backgroundImage:
                                      NetworkImage(owener.image ?? ""),
                                ),
                                //
                                Spacer(flex: 3),
                                Text.rich(
                                  TextSpan(
                                      text: owener.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: '\n${owener.username}',
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
                  BottomText(
                    "Add Class",
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => AddClass(
                                rutinId: widget.rutinId,
                                classId: id,
                                isEdit: true,
                              )),
                    ),
                  ),

                  BottomText(
                    "Add Priode",
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              AppPriodePage(rutinId: widget.rutinId)),
                    ),
                  ),

                  //
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
                        save == true
                            ? unSaveRutin()
                            : Rutin_Req().chackStatus(context);
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
        Uri.parse('http://192.168.0.125:3000/class/delete/$classId'),
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
//.. list of days ...///

class ListOfDays extends StatelessWidget {
  List<Day?> day;
  ListOfDays(this.day, {super.key});

  @override
  Widget build(BuildContext context) {
    return day.isEmpty
        ? SizedBox(height: 100, width: 200, child: Text("No Class"))
        : Row(
            children: List.generate(
              day.length,
              (index) => ClassContainer(
                  instractorname: day[index]?.instuctorName,
                  roomnum: day[index]?.room,
                  subCode: day[index]?.subjectcode,
                  start: day[index]!.start,
                  end: day[index]!.end,
                  startTime: day[index]!.startTime,
                  endTime: day[index]?.endTime,
                  weakday: day[index]?.weekday,
                  classname: day[index]?.name,
                  previous_end:
                      index == 0 ? day[index]!.end : day[index - 1]!.end,
                  weakdayIndex: day[index]?.weekday,

                  //
                  isLast: day.length - 1 == index,

                  // ontap to go summay page..//
                  onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SummaryScreen(
                            classId: day[index]!.id,
                          ),
                        ),
                      )),
            ),
          );
  }
}

class ListOfPriodes extends StatelessWidget {
  List<Priode?> Priodes;
  String rutinId;
  ListOfPriodes(this.Priodes, this.rutinId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        Priodes.length,
        (index) => Priodes.isEmpty
            ? Text("No Priode")
            : PriodeContaner(
                startTime: Priodes[index]!.startTime,
                endtime: Priodes[index]!.endTime,
                priode: index,
                lenght: 1,

                // ontap to go summay page..//
                onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AppPriodePage(
                          rutinId: rutinId,
                        ),
                      ),
                    )),
      ),
    );
  }
}
//

class ListOfWeakdays extends StatelessWidget {
  const ListOfWeakdays({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Empty(corner: true),
        Column(
          children: List.generate(
            7,
            (indexofdate) => DaysContaner(
              indexofdate: indexofdate,
            ),
          ),
        ),
      ],
    );
  }
}
