import 'dart:convert';

import 'package:classmate/ui/bottom_items/Home/Full_routine/utils/popup.dart';

FindClass findClassFromJson(String str) => FindClass.fromJson(json.decode(str));

String findClassToJson(FindClass data) => json.encode(data.toJson());

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
        classes: Classs.fromJson(json["classs"]),
        weekdays: List<Weekday>.from(
            json["weekdays"].map((x) => Weekday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "classs": classes.toJson(),
        "weekdays": List<dynamic>.from(weekdays.map((x) => x.toJson())),
      };
}

class Classs {
  String id;
  String name;
  String instuctorName;
  String subjectcode;
  String rutinId;
  int v;

  Classs({
    required this.id,
    required this.name,
    required this.instuctorName,
    required this.subjectcode,
    required this.rutinId,
    required this.v,
  });

  factory Classs.fromJson(Map<String, dynamic> json) => Classs(
        id: json["_id"],
        name: json["name"],
        instuctorName: json["instuctor_name"],
        subjectcode: json["subjectcode"],
        rutinId: json["routine_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "subjectcode": subjectcode,
        "routine_id": rutinId,
        "__v": v,
      };
}

class Weekday {
  dynamic id;
  String routineId;
  String classId;
  String room;
  int num;
  DateTime startTime;
  DateTime endTime;

  Weekday({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.num,
    required this.startTime,
    required this.endTime,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        id: json["_id"].toString(),
        routineId: json["routine_id"],
        classId: json["class_id"],
        room: json["room"],
        num: json["num"],
        startTime: DateTime.parse(endMaker(json["start_time"])),
        endTime: DateTime.parse(endMaker(json["end_time"])),
      );

  Map<String, dynamic> toJson() => {
        "_id": id.toHexString(),
        "routine_id": routineId,
        "class_id": classId,
        "room": room,
        "num": num,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}
