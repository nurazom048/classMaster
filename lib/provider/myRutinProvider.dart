import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/moidels.dart';

class MyRutinProvider with ChangeNotifier {
  List<Map<String, dynamic>> MyClass = [
    // {
    //   "instructorname": " Mrx ",
    //   "subjectcode": "d",
    //   "roomnum": "roomnum",
    //   "startingpriode": 1.0,
    //   "endingpriode": 3.0,
    //   "start_time": DateTime(2022, 09, 03, 8, 40),
    //   "end_time": DateTime(2022, 09, 03, 9, 30),
    // },
    // {
    //   "instructorname": " Mrx ",
    //   "subjectcode": "d",
    //   "roomnum": "roomnum",
    //   "startingpriode": 1.0,
    //   "endingpriode": 1.0,
    //   "start_time": DateTime(2022, 09, 03, 9, 30),
    //   "end_time": DateTime(2022, 09, 03, 10, 15),
    // },
    // {
    //   "instructorname": " Mrx ",
    //   "subjectcode": "d",
    //   "roomnum": "roomnum",
    //   "startingpriode": 1.0,
    //   "endingpriode": 3.0,
    //   "start_time": DateTime(2022, 09, 03, 10, 15),
    //   "end_time": DateTime(2022, 09, 03, 11, 00),
    // },
  ];

  void addclass(newclass) {
    MyClass.add(newclass);

    notifyListeners();
  }
}
