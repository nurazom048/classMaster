import 'package:flutter/material.dart';
import 'package:table/old/freash.dart';
import 'package:table/ui/widgets/corner_box.dart';
import 'package:table/ui/widgets/custom_rutin_card.dart';
import 'package:table/ui/widgets/priodeContaner.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';

class AllRutins extends StatelessWidget {
  AllRutins({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //... topbar .../
          CustomTopBar("All Rutin",
              icon: Icons.add_circle_outlined, ontap: () {}),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //... hedding .../
                MyText("All Rutin"),

                //... all rutins...//
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        3, (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                  ),
                ),

                //... hedding .../
                MyText("Pined Rutin"),

                //... all rutins...//
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        3, (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                  ),
                ),

                //... hedding .../
                MyText("my Rutin"),

                //... all rutins...//
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        3, (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
