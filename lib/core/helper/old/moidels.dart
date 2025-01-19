import 'package:flutter/material.dart';

class Classmodel {
  String instructorname, subjectcode, roomnum;
  int startingpriode, endingpriode;
  int? weith;
  String? mainpic, classsumary;

  Classmodel(
      {required this.instructorname,
      required this.subjectcode,
      this.mainpic,
      this.classsumary,
      required this.roomnum,
      required this.startingpriode,
      required this.endingpriode,
      this.weith});
}

class Priodemodel {
  List<Classmodel> date;

  Priodemodel({
    required this.date,
  });
}

class Addpriode {
  TimeOfDay startingpriode, endingpriode;

  String? mainpic, classsumary;

  Addpriode({
    this.mainpic,
    this.classsumary,
    required this.startingpriode,
    required this.endingpriode,
  });
}
