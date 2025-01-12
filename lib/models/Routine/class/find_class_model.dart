import 'dart:convert';
import '../../../ui/bottom_items/Home/Full_routine/utils/popup.dart';

FindClass findClassFromJson(String str) => FindClass.fromJson(json.decode(str));

class FindClass {
  String message;
  Classs classes;
  List<Weekday> weekdays;

  FindClass({
    required this.message,
    required this.classes,
    required this.weekdays,
  });

  factory FindClass.fromJson(Map<String, dynamic> json) => FindClass(
        message: json["message"],
        classes: Classs.fromJson(json["classes"]),
        weekdays: json["weekdays"] is List
            ? List<Weekday>.from(
                json["weekdays"].map((x) => Weekday.fromJson(x)))
            : [], // Return empty list if weekdays is not a list
      );
}

class Classs {
  String id;
  String name;
  String instuctorName;
  String subjectcode;
  String routineId;

  Classs({
    required this.id,
    required this.name,
    required this.instuctorName,
    required this.subjectcode,
    required this.routineId,
  });

  factory Classs.fromJson(Map<String, dynamic> json) => Classs(
        id: json["id"],
        name: json["name"],
        instuctorName: json["instructorName"],
        subjectcode: json["subjectCode"],
        routineId: json["routineId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "instructorName": instuctorName,
        "subjectCode": subjectcode,
        "routineId": routineId,
      };
}

class Weekday {
  dynamic id;
  String routineId;
  String classId;
  String room;
  DateTime startTime;
  DateTime endTime;

  Weekday({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.startTime,
    required this.endTime,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        id: json["id"].toString(),
        routineId: json["routineId"],
        classId: json["classId"],
        room: json["room"],
        startTime: DateTime.parse(endMaker(json["startTime"])),
        endTime: DateTime.parse(endMaker(json["endTime"])),
      );
}
