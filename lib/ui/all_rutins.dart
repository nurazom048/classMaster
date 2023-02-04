import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/rutin_screen.dart';
import 'package:table/ui/widgets/custom_rutin_card.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';
import 'package:http/http.dart' as http;

class AllRutins extends StatelessWidget {
  List myrutines;
  AllRutins({super.key, required this.myrutines});

  allrutin(context) async {
    List<Map<String, dynamic>> classes = [];

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.31.229:3000/class/63db3dcb2277cca75bd6e0e9/all/class'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = json.decode(response.body);
        responseMap.forEach((key, value) {
          classes.add({"day": key, "classes": value});
        });
        // ;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RutinScreem(allClassList: classes)));
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
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //... topbar .../
            CustomTopBar("All Rutin",
                icon: Icons.add_circle_outlined, ontap: () {}),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
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
                          myrutines.isEmpty ? 1 : myrutines.length,
                          (index) => myrutines.isEmpty
                              ? const Text("You Dont Have any Rutin created")
                              : InkWell(
                                  onTap: () {
                                    print(myrutines[index]["_id"]);
                                    allrutin(context);
                                  },
                                  child: CustomRutinCard(
                                      rutinname: myrutines[index]["name"]))),
                    ),
                  ),

                  //... hedding .../
                  MyText("Pined Rutin"),

                  //... all rutins...//
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(3,
                          (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                    ),
                  ),

                  //... hedding .../
                  MyText("my Rutin"),

                  //... all rutins...//
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(3,
                          (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
