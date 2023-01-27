import 'package:flutter/material.dart';
import 'package:table/old/freash.dart';

// ignore: must_be_immutable
class Classdetails extends StatelessWidget {
  String instructorname, roomnumber, sunjectcode;

  Classdetails(
      {super.key,
      required this.instructorname,
      required this.roomnumber,
      required this.sunjectcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CustomTopBar("Class Detals", ontap: () {}),

        Container(
          height: 150,
          width: double.infinity,
          color: Colors.black12,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://ak.picdn.net/shutterstock/videos/4893908/thumb/1.jpg"),
                  radius: 50),
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text("InstractorName   :  "
                      "$instructorname"),
                  Text("  subject Code     :"
                      "     $roomnumber"),
                  Text("Room Name    :   "
                      "$sunjectcode "),
                  // Text(DateFormat('EEEE').format(yourDate).toString()),
                ],
              )
            ],
          ),
        ),
        //
        const Divider(height: 5),
        Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          width: double.infinity,
          color: Colors.black12,
          child: Text(sunjectcode),
        )
      ]),
    );
  }
}
