// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';

class CustomRutinCard extends StatelessWidget {
  String rutinname;
  String? name, username, profilePicture;
  dynamic onTap, onLongPress;

  CustomRutinCard({
    super.key,
    required this.rutinname,
    this.name,
    this.username,
    this.profilePicture,
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
      margin: const EdgeInsets.only(top: 20, right: 10),
      height: 250,
      width: 220,
      color: Colors.black12,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal, child: Priode()),
                      Wrap(
                          direction: Axis.vertical,
                          children: List.generate(
                            3,
                            (index) => DaysContaner(
                              indexofdate: index,
                              ismini: true,
                            ),
                          )),
                    ],
                  ),

                  //
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: 240,
                      // padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(color: Colors.black12),
                      child: Center(
                        child: Text(rutinname,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
              MiniAccountCard(
                name: name ?? "             ",
                username: username ?? "             ",
                profilePicture: profilePicture ?? "",
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
            ? Empty(corner: true, mini: true)
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

class MiniAccountCard extends StatelessWidget {
  String name, username, profilePicture;
  MiniAccountCard({
    required this.name,
    required this.username,
    required this.profilePicture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 248,
      color: Colors.black12,
      child: Row(
        children: [
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.amber,
            backgroundImage: NetworkImage(profilePicture),
          ),
          const SizedBox(width: 6),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                TextSpan(
                  text: '\n$username',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
