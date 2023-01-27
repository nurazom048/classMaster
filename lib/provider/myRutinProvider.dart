import 'package:flutter/material.dart';

class MyRutinProvider with ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> rutin = {
    //

    "Name": <Map<String, dynamic>>[
      {
        "name": " electrical",
      },
    ],

    "Sunday": <Map<String, dynamic>>[
      {
        "instructorname": " wow",
        "subjectcode": "d",
        "roomnum": "roomnum",
        "startingpriode": 1,
        "endingpriode": 3.0,
        "start_time": DateTime(2022, 09, 03, 8, 40),
        "end_time": DateTime(2022, 09, 03, 9, 30),
      },
      {
        "instructorname": " Mrx ",
        "subjectcode": "d",
        "roomnum": "roomnum",
        "startingpriode": 1,
        "endingpriode": 1,
        "start_time": DateTime(2022, 09, 03, 9, 30),
        "end_time": DateTime(2022, 09, 03, 10, 15),
      },
      {
        "instructorname": " Mrx ",
        "subjectcode": "d",
        "roomnum": "roomnum",
        "startingpriode": 1,
        "endingpriode": 3,
        "start_time": DateTime(2022, 09, 03, 10, 15),
        "end_time": DateTime(2022, 09, 03, 11, 00),
      },
    ],
  };

//

  void addclass(Map<String, dynamic> newclass) {
    rutin["Sunday"]!.add(newclass);
    notifyListeners();
  }
}
