// ignore_for_file: unused_local_variable, avoid_print, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/bottom_items/Home/all_class-rutin.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _AllRutinsState();
}

class _AllRutinsState extends State<HomeScreen> {
  //
  final rutinName = TextEditingController();
  String? message;

  //... ALl rutin rutin
  var myRutines;
  Future<void> myAllRutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('http://192.168.31.229:3000/rutin/allrutins'),
        headers: {'Authorization': 'Bearer $getToken'});

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body);
      final routines = json.decode(response.body)["user"]["routines"];
      //
      myRutines = routines;

      //print response
      print("MyAllRutin");
      print(routines);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //... create rutin
  Future<void> CreatRutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('http://192.168.31.229:3000/rutin/create'),
        body: {"name": rutinName.text},
        headers: {'Authorization': 'Bearer $getToken'});

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body);

      //print response
      print("rutin created successfully");
      print(res);
    } else {
      throw Exception('Failed to load data');
    }
  }
//

  @override
  Widget build(BuildContext context) {
    print(myRutines);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //... topbar .../
              CustomTopBar(
                "All Rutins",
                icon: Icons.add_circle_outlined,
                ontap: () => _showDialog(context, rutinName),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //... hedding .../
                      MyText("My All Rutin"),

                      //... all rutins...//
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                            future: myAllRutin(),
                            builder: (context, snapshoot) {
                              if (snapshoot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Waiting");
                              } else {
                                // print(myRutines.length);
                                // print(myRutines[0]["_id"]);

                                return Row(
                                  children: List.generate(
                                      myRutines.length == 0
                                          ? 1
                                          : myRutines.length,
                                      (index) => myRutines.length == 0
                                          ? const Text(
                                              "You Dont Have any Rutin created")
                                          : InkWell(
                                              child: CustomRutinCard(
                                                rutinname: myRutines[index]
                                                    ["name"],
                                                profilePicture: "",
                                                name: myRutines[index]
                                                    ["ownerid"]["name"],
                                                username: myRutines[index]
                                                    ["ownerid"]["name"],

                                                //
                                              ),

                                              //
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllClassScreen(
                                                            rutinId:
                                                                myRutines[index]
                                                                    ["_id"],
                                                          ))),
                                            )),
                                );
                              }
                            }),
                      ),
                      //... hedding .../
                      MyText("Saved Rutin"),

                      //... all rutins...//
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              3,
                              (index) =>
                                  CustomRutinCard(rutinname: "ET / 7 /1")),
                        ),
                      ),

                      //... hedding .../
                      MyText("Others Rutins"),

                      //... all rutins...//
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              3,
                              (index) =>
                                  CustomRutinCard(rutinname: "ET / 7 /1")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//.... Create Rutin
  void _showDialog(context, RutinName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" Create Rutin "),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: RutinName,
                decoration: const InputDecoration(hintText: "Enter Rutin name"),
              ),
              const SizedBox(height: 17),

              //... create rutin button .../
              Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.blue,
                  child: const Text("Create"),
                  onPressed: () {
                    CreatRutin();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

///.... onlong press
onLongpress_class(context, rutinId, message) {
  //,, delete rutin
  Future<void> deleteRutin() async {
    print(rutinId);

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.delete(
        Uri.parse('http://192.168.31.229:3000/class/delete/$rutinId'),
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

          // BottomText(
          //   "Edit",
          //   onPressed: () => Navigator.push(
          //                                         context,
          //                                         MaterialPageRoute(
          //                                             builder: (context) =>
          //                                                 AllClassScreen(
          //                                                   rutinId: ""

          //                                                        ,
          // ),),),),

          //.... remove
          BottomText(
            "Remove",
            color: CupertinoColors.destructiveRed,
            onPressed: () => deleteRutin(),
          ),
          //.... Cancel
          BottomText("Cancel"),
        ],
      ),
    ),
  );
}
