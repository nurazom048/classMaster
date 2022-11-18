import 'package:flutter/material.dart';

class Classdetails extends StatelessWidget {
  String instractorname, classsumary;
  String subjectcode, roomnum;

  Classdetails(
      {super.key,
      required this.instractorname,
      required this.classsumary,
      required this.subjectcode,
      required this.roomnum});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                  radius: 50),
              const SizedBox(width: 30),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Text("InstractorName: $instractorname"),
                  Text("  subject Code: $subjectcode"),
                  Text("InstractorName: $roomnum"),
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
          child: Text(classsumary),
        )
      ]),
    );
  }
}
