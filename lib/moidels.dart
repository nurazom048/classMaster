import 'package:flutter/services.dart';

List<Classmodel> sunday = [
  Classmodel(
      instructorname: "Sunday",
      subjectcode: "1",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "roomnum"),
  Classmodel(
      instructorname: "Sun 1",
      subjectcode: "665",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "1"),
  Classmodel(
      instructorname: "Sun 1",
      subjectcode: "66",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "2"),
  Classmodel(
      instructorname: "Sun 3",
      subjectcode: "663",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "4"),
  Classmodel(
      instructorname: "Sun 3",
      subjectcode: "66",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "4"),
  Classmodel(
      instructorname: "Sun 3",
      subjectcode: "66f",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "4"),
  Classmodel(
      instructorname: "Sun 3",
      subjectcode: "66",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "4"),
  Classmodel(
      instructorname: "Sun 3",
      subjectcode: "66f",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "4"),
];
//
//monday
List<Classmodel> Mobday = [
  Classmodel(
      instructorname: "Monday",
      subjectcode: "subjectcode",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "roomnum"),
  Classmodel(
      instructorname: "mon 1",
      subjectcode: "subjectcode",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "roomnum"),
  Classmodel(
      instructorname: "mon 2",
      subjectcode: "subjectcode",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "roomnum"),
  Classmodel(
      instructorname: "mon3 3",
      subjectcode: "subjectcode",
      mainpic: "mainpic",
      classsumary: "classsumary",
      roomnum: "roomnum")
];

class Classmodel {
  String instructorname, subjectcode, roomnum, mainpic, classsumary;

  Classmodel({
    required this.instructorname,
    required this.subjectcode,
    required this.mainpic,
    required this.classsumary,
    required this.roomnum,
  });
}

class Priodemodel {
  List<Classmodel> date;

  Priodemodel({
    required this.date,
  });
}

List<Priodemodel> priode = [
  Priodemodel(date: [
    Classmodel(
        instructorname: "Sunday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "B1",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Ba2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),

  /// monday
  Priodemodel(date: [
    Classmodel(
        instructorname: "monday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2sd",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),

  // Tuesday

  Priodemodel(date: [
    Classmodel(
        instructorname: "Tuesday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),
// Wednesday
  Priodemodel(date: [
    Classmodel(
        instructorname: "Wednesday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),
// Thursday
  Priodemodel(date: [
    Classmodel(
        instructorname: "Thursday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),
// Friday
  Priodemodel(date: [
    Classmodel(
        instructorname: "Friday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),
//sat
  Priodemodel(date: [
    Classmodel(
        instructorname: "saterday",
        subjectcode: "12sasds3",
        mainpic: "dfssa",
        classsumary: "clasdssafssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "b2",
        subjectcode: "123",
        mainpic: "",
        classsumary: "classsssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "UfKsdR",
        subjectcode: "6671sd1",
        mainpic: "",
        classsumary: "classdssumary",
        roomnum: ''),
    Classmodel(
        instructorname: "TMADSsJ",
        subjectcode: "3",
        mainpic: "",
        classsumary: "classsrsumary",
        roomnum: ''),
    Classmodel(
        instructorname: "Mnewee",
        subjectcode: "12ee3",
        mainpic: "",
        classsumary: "clasdwessumary",
        roomnum: ''),
  ]),
];
