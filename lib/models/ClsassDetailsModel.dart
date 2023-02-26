import 'dart:convert';

import 'package:table/models/Account_models.dart';

ClassDetailsModel classDetailsModelFromJson(String str) =>
    ClassDetailsModel.fromJson(json.decode(str));

String classDetailsModelToJson(ClassDetailsModel data) =>
    json.encode(data.toJson());

class ClassDetailsModel {
  ClassDetailsModel({
    required this.priodes,
    required this.classes,
    required this.owener,

    /// hey chat gpt add the owner fild
  });

  List<Priode> priodes;
  Classes classes;
  AccountModels owener;

  factory ClassDetailsModel.fromJson(Map<String, dynamic> json) =>
      ClassDetailsModel(
        priodes:
            List<Priode>.from(json["priodes"].map((x) => Priode.fromJson(x))),
        classes: Classes.fromJson(json["Classes"]),
        owener: AccountModels.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "priodes": List<dynamic>.from(priodes.map((x) => x.toJson())),
        "Classes": classes.toJson(),
      };
}

class Classes {
  Classes({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  List<Day?> sunday;
  List<Day?> monday;
  List<Day?> tuesday;
  List<Day?> wednesday;
  List<Day?> thursday;
  List<Day?> friday;
  List<Day?> saturday;

  factory Classes.fromJson(Map<String, dynamic> json) => Classes(
        sunday: List<Day>.from(json["Sunday"].map((x) => Day.fromJson(x))),
        monday: List<Day>.from(json["Monday"].map((x) => Day.fromJson(x))),
        tuesday: List<Day>.from(json["Tuesday"].map((x) => Day.fromJson(x))),
        wednesday:
            List<Day>.from(json["Wednesday"].map((x) => Day.fromJson(x))),
        thursday: List<Day>.from(json["Thursday"].map((x) => Day.fromJson(x))),
        friday: List<Day>.from(json["Friday"].map((x) => x)),
        saturday: List<Day>.from(json["Saturday"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Sunday": List<dynamic>.from(sunday.map((x) => x?.toJson())),
        "Monday": List<dynamic>.from(monday.map((x) => x?.toJson())),
        "Tuesday": List<dynamic>.from(tuesday.map((x) => x?.toJson())),
        "Wednesday": List<dynamic>.from(wednesday.map((x) => x?.toJson())),
        "Thursday": List<dynamic>.from(thursday.map((x) => x?.toJson())),
        "Friday": List<dynamic>.from(friday.map((x) => x)),
        "Saturday": List<dynamic>.from(saturday.map((x) => x?.toJson())),
      };
}

class Day {
  Day({
    required this.id,
    required this.name,
    required this.instuctorName,
    required this.room,
    required this.subjectcode,
    required this.start,
    required this.end,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.hasClass,
  });

  String id;
  String name;
  String instuctorName;
  String room;
  String subjectcode;
  int start;
  int end;
  int weekday;
  DateTime startTime;
  DateTime endTime;
  String hasClass;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["_id"],
        name: json["name"],
        instuctorName: json["instuctor_name"],
        room: json["room"],
        subjectcode: json["subjectcode"],
        start: json["start"],
        end: json["end"],
        weekday: json["weekday"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        hasClass: json["has_class"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "room": room,
        "subjectcode": subjectcode,
        "start": start,
        "end": end,
        "weekday": weekday,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "has_class": hasClass,
      };
}

class Priode {
  Priode({
    required this.startTime,
    required this.endTime,
    required this.id,
  });

  DateTime startTime;
  DateTime endTime;
  String id;

  factory Priode.fromJson(Map<String, dynamic> json) => Priode(
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "_id": id,
      };
}
