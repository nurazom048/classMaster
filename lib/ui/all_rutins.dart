import 'package:flutter/material.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/all_class-rutin.dart';

import 'package:table/ui/widgets/custom_rutin_card.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';

class AllRutins extends StatelessWidget {
  List myrutines;
  AllRutins({super.key, required this.myrutines});

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
              CustomTopBar("All Rutin",
                  icon: Icons.add_circle_outlined, ontap: () {}),
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
                              myrutines.isEmpty ? 1 : myrutines.length,
                              (index) => myrutines.isEmpty
                                  ? const Text(
                                      "You Dont Have any Rutin created")
                                  : InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllClassScreen(
                                                    rutinId: myrutines[index]
                                                        ["_id"],
                                                  ))),
                                      child: CustomRutinCard(
                                          rutinname: myrutines[index]
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
}
