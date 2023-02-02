import 'package:flutter/material.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/rutin_screen.dart';
import 'package:table/ui/widgets/custom_rutin_card.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';

class AllRutins extends StatelessWidget {
  List myrutines;
  AllRutins({super.key, required this.myrutines});

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
                          myrutines.length,
                          (index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RutinScreem()),
                                );
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
