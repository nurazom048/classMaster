// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/mini_accountcard.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';
import '../models/rutins/rutins.dart';
import '../ui/bottom_items/Home/full_rutin/screen/full_rutin_view.dart';

class CustomRutinCard extends StatelessWidget {
  Routine rutinModel;

  dynamic onTap, onLongPress;

  CustomRutinCard({
    super.key,
    required this.rutinModel,
    this.onTap,
    this.onLongPress,
  });

  List<Map<String, dynamic>> mypriodelist = [
    {
      "start_time": DateTime(2022, 09, 03, 8, 59),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
    {
      "start_time": DateTime(2022, 09, 03, 8, 40),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, right: 10),
      width: MediaQuery.of(context).size.width * 0.47,
      color: Colors.black12,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: onTap ??
              () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullRutineView(
                        rutinName: rutinModel.name,
                        rutinId: rutinModel.id,
                      ),
                    ),
                  ),
          onLongPress: onLongPress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal, child: Priode()),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              children: List.generate(
                            3,
                            (index) => DaysContaner(
                              indexofdate: index,
                              ismini: true,
                            ),
                          )),

                          //
                          Column(
                            children: [
                              const MyText("  Last Update",
                                  padding: EdgeInsets.only(top: 5)),
                              const SizedBox(height: 5),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),

                  //
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 240,
                          decoration:
                              const BoxDecoration(color: Colors.black12),
                          child: Center(
                            child: Text(rutinModel.name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MiniAccountCard(
                name: rutinModel.owner.name ?? '',
                username: rutinModel.owner.username,
                profilePicture: rutinModel.owner.image ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Wrap Priode() {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
        5,
        (index) => index == 0
            ? const Empty(corner: true, mini: true)
            : Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(68, 114, 196, 40),
                    border: Border(
                        right: BorderSide(color: Colors.black45, width: 1))),
                child: Column(
                  children: [
                    Text(index.toString(),
                        style: const TextStyle(fontSize: 10)),
                    const Divider(
                        color: Colors.black87, height: 1, thickness: .5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            formatTime(
                              mypriodelist[index]["start_time"],
                            ),
                            style: const TextStyle(fontSize: 10)),
                        Text(formatTime(mypriodelist[index]["end_time"]),
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}
