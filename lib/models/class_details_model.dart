import 'dart:convert';

import 'package:classmate/ui/bottom_items/Collection%20Fetures/models/account_models.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/utils/popup.dart';

NewClassDetailsModel newClassDetailsModelFromJson(String str) =>
    NewClassDetailsModel.fromJson(json.decode(str));

String newClassDetailsModelToJson(NewClassDetailsModel data) =>
    json.encode(data.toJson());

class NewClassDetailsModel {
  String id;
  String routineName;
  List<AllClass> allClass;
  Classes classes;
  AccountModels owner;

  NewClassDetailsModel({
    required this.id,
    required this.routineName,
    required this.classes,
    required this.owner,
    required this.allClass,
  });

  factory NewClassDetailsModel.fromJson(Map<String, dynamic> json) =>
      NewClassDetailsModel(
        id: json["_id"],
        routineName: json["routine_name"],
        classes: Classes.fromJson(json["Classes"] ?? {}),
        owner: AccountModels.fromJson(json["owner"]),
        allClass: List<AllClass>.from(
            json["AllClass"].map((x) => AllClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "routine_name": routineName,
        "Classes": classes.toJson(),
        "owner": owner.toJson(),
        "AllClass": List<dynamic>.from(allClass.map((x) => x.toJson())),
      };
}

class Classes {
  List<Day> sunday;
  List<Day> monday;
  List<Day> tuesday;
  List<Day> wednesday;
  List<Day> thursday;
  List<Day> friday;
  List<Day> saturday;

  Classes({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  factory Classes.fromJson(Map<String, dynamic> json) => Classes(
        sunday:
            List<Day>.from(json["Sunday"]?.map((x) => Day.fromJson(x)) ?? []),
        monday:
            List<Day>.from(json["Monday"]?.map((x) => Day.fromJson(x)) ?? []),
        tuesday:
            List<Day>.from(json["Tuesday"]?.map((x) => Day.fromJson(x)) ?? []),
        wednesday: List<Day>.from(
            json["Wednesday"]?.map((x) => Day.fromJson(x)) ?? []),
        thursday:
            List<Day>.from(json["Thursday"]?.map((x) => Day.fromJson(x)) ?? []),
        friday:
            List<Day>.from(json["Friday"]?.map((x) => Day.fromJson(x)) ?? []),
        saturday:
            List<Day>.from(json["Saturday"]?.map((x) => Day.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "Sunday": List<dynamic>.from(sunday.map((x) => x.toJson())),
        "Monday": List<dynamic>.from(monday.map((x) => x.toJson())),
        "Tuesday": List<dynamic>.from(tuesday.map((x) => x.toJson())),
        "Wednesday": List<dynamic>.from(wednesday.map((x) => x.toJson())),
        "Thursday": List<dynamic>.from(thursday.map((x) => x.toJson())),
        "Friday": List<dynamic>.from(friday.map((x) => x.toJson())),
        "Saturday": List<dynamic>.from(saturday.map((x) => x.toJson())),
      };
}

class Day {
  String room;
  String id;
  String routineId;
  ClassId classId;
  int num;
  DateTime startTime;
  DateTime endTime;

  Day({
    required this.room,
    required this.id,
    required this.routineId,
    required this.classId,
    required this.num,
    required this.startTime,
    required this.endTime,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        room: json["room"],
        id: json["_id"],
        routineId: json["routine_id"],
        classId: ClassId.fromJson(json["class_id"]),
        num: json["num"],
        startTime: DateTime.parse(endMaker(json["start_time"])),
        endTime: DateTime.parse(endMaker(json["end_time"])),
      );

  Map<String, dynamic> toJson() => {
        "room": room,
        "_id": id,
        "routine_id": routineId,
        "class_id": classId.toJson(),
        "num": num,
        "start_time": endMaker(startTime.toIso8601String().toString()),
        "end_time": endMaker(endTime.toIso8601String().toString()),
      };
}

class ClassId {
  String id;
  String name;
  String instuctorName;
  String? room;
  String subjectcode;
  String routineId;

  ClassId({
    required this.id,
    required this.name,
    required this.instuctorName,
    this.room,
    required this.subjectcode,
    required this.routineId,
  });

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
        name: json["name"],
        instuctorName: json["instuctor_name"],
        room: json["room"],
        subjectcode: json["subjectcode"],
        routineId: json["routine_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "room": room,
        "subjectcode": subjectcode,
        "routine_id": routineId,
      };
}

class AllClass {
  String id;
  String name;
  String instuctorName;
  String subjectcode;
  List<String> weekday;
  String routineId;
  int v;

  AllClass({
    required this.id,
    required this.name,
    required this.instuctorName,
    required this.subjectcode,
    required this.weekday,
    required this.routineId,
    required this.v,
  });

  factory AllClass.fromJson(Map<String, dynamic> json) => AllClass(
        id: json["_id"],
        name: json["name"],
        instuctorName: json["instuctor_name"],
        subjectcode: json["subjectcode"],
        weekday: List<String>.from(json["weekday"].map((x) => x)),
        routineId: json["routine_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "subjectcode": subjectcode,
        "weekday": List<dynamic>.from(weekday.map((x) => x)),
        "routine_id": routineId,
        "__v": v,
      };
}
