import 'package:flutter/material.dart';

import 'moidels.dart';

// ignore: must_be_immutable
class Classdetails extends StatelessWidget {
  Classmodel classdate;

  Classdetails({super.key, required this.classdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Class Detals")),
      body: Column(children: [
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
                      "${classdate.instructorname.toString()}"),
                  Text("  subject Code     :"
                      "     ${classdate.subjectcode.toString()}"),
                  Text("InstractorName   :   "
                      "${classdate.instructorname.toString()}"),
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
          child: Text(classdate.classsumary),
        )
      ]),
    );
  }
}
