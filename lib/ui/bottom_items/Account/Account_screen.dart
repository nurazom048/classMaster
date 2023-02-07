// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/widgets/AccountCard.dart';
import 'package:table/widgets/AppBarCustom.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

var accountData;
var myRutines;

//... Account data
Future _AccountData() async {
  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();
  final String? getToken = prefs.getString('Token');

  final response = await http.post(
      Uri.parse('http://192.168.31.229:3000/rutin/allrutins'),
      headers: {'Authorization': 'Bearer $getToken'});

  if (response.statusCode == 200) {
    //.. responce
    final res = json.decode(response.body)["user"];
    final routines = json.decode(response.body)["user"]["routines"];
    //
    myRutines = routines;
    accountData = res;
    //print response
    print("Account data ");
    print(res["_id"]);
  } else {
    throw Exception('Failed to load data');
  }
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //... AppBar.....//
            AppbarCustom(
                title: "Account", actionIcon: const Icon(Icons.more_vert)),

            FutureBuilder(
                future: _AccountData(),
                builder: (context, snapshoot) {
                  if (snapshoot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //... Accoumt Info ..//
                          AccountCard(
                            ProfilePicture: "",
                            name: accountData["name"],
                            username: accountData["username"],
                            ontapLogOut: () => _showConfirmationDialog(context),
                          ),

                          //...My Rutiners...//
                          MyText("my Rutin"),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                myRutines.length,
                                (index) => InkWell(
                                  child: CustomRutinCard(
                                    rutinname: myRutines[index]["name"],
                                    username: myRutines[index]["ownerid"]
                                        ["username"],
                                    name: myRutines[index]["ownerid"]["name"],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

Future<void> _showConfirmationDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text(
          "Are you sure to log out?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(
              "Yes",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            child: Text(
              "No",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
