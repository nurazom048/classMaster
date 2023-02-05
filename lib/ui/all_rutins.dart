// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/all_class-rutin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AllRutins extends StatefulWidget {
  List myrutines;
  AllRutins({super.key, required this.myrutines});

  @override
  State<AllRutins> createState() => _AllRutinsState();
}

class _AllRutinsState extends State<AllRutins> {
  //
  final RutinName = TextEditingController();

  //... create rutin
  Future<void> CreatRutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('http://192.168.31.229:3000/rutin/create'),
        body: {"name": RutinName.text},
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //... topbar .../
              CustomTopBar(
                "All Rutin",
                icon: Icons.add_circle_outlined,
                ontap: () => _showDialog(context, RutinName),
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
                        child: Row(
                          children: List.generate(
                              widget.myrutines.isEmpty
                                  ? 1
                                  : widget.myrutines.length,
                              (index) => widget.myrutines.isEmpty
                                  ? const Text(
                                      "You Dont Have any Rutin created")
                                  : InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllClassScreen(
                                                    rutinId:
                                                        widget.myrutines[index]
                                                            ["_id"],
                                                  ))),
                                      child: CustomRutinCard(
                                          rutinname: widget.myrutines[index]
                                              ["name"]))),
                        ),
                      ),

                      //... hedding .../
                      MyText("Pined Rutin"),

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
                      MyText("my Rutin"),

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
