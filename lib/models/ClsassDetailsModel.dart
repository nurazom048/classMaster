// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:table/models/Account_models.dart';

NewClassDetailsModel newClassDetailsModelFromJson(String str) =>
    NewClassDetailsModel.fromJson(json.decode(str));

class NewClassDetailsModel {
  NewClassDetailsModel({
    required this.id,
    required this.rutinName,
    required this.priodes,
    required this.classes,
    required this.owner,
  });

  String id;
  String rutinName;
  List<Priode> priodes;
  NewClasses classes;
  AccountModels owner;

  factory NewClassDetailsModel.fromJson(Map<String, dynamic> json) =>
      NewClassDetailsModel(
        id: json["_id"] ?? '',
        rutinName: json["rutin_name"] ?? "",
        priodes:
            List<Priode>.from(json["priodes"].map((x) => Priode.fromJson(x))),
        classes: NewClasses.fromJson(json["Classes"]),
        owner: AccountModels.fromJson(json["owner"]),
      );
}

class NewClasses {
  NewClasses({
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  List<Day> sunday;
  List<Day> monday;
  List<Day> tuesday;
  List<Day> wednesday;
  List<Day> thursday;
  List<Day> friday;
  List<Day> saturday;

  factory NewClasses.fromJson(Map<String?, dynamic> json) => NewClasses(
        sunday: List<Day>.from(json["Sunday"].map((x) => Day.fromJson(x))),
        monday: List<Day>.from(json["Monday"].map((x) => Day.fromJson(x))),
        tuesday: List<Day>.from(json["Tuesday"].map((x) => Day.fromJson(x))),
        wednesday:
            List<Day>.from(json["Wednesday"].map((x) => Day.fromJson(x))),
        thursday: List<Day>.from(json["Thursday"].map((x) => Day.fromJson(x))),
        friday: List<Day>.from(json["Friday"].map((x) => Day.fromJson(x))),
        saturday: List<Day>.from(json["Saturday"].map((x) => Day.fromJson(x))),
      );
}

/////////////////////////////////////////////////////////////////

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
    this.startTime,
    this.endTime,
  });

  String id;
  String name;
  String instuctorName;
  String room;
  String subjectcode;
  int start;
  int end;
  int weekday;
  DateTime? startTime;
  DateTime? endTime;

  factory Day.fromJson(Map<String?, dynamic> json) => Day(
        id: json["_id"] ?? '',
        name: json["name"] ?? '',
        instuctorName: json["instuctor_name"] ?? '',
        room: json["room"],
        subjectcode: json["subjectcode"] ?? '',
        start: json["start"] ?? '',
        end: json["end"] ?? '',
        weekday: json["weekday"] ?? '',
        startTime: json["start_time"] != null
            ? DateTime.parse(json["start_time"])
            : null,
        endTime:
            json["end_time"] != null ? DateTime.parse(json["end_time"]) : null,
      );
}

class Priode {
  Priode({
    required this.priode_number,
    required this.startTime,
    required this.endTime,
    required this.id,
  });
  dynamic priode_number;
  DateTime startTime;
  DateTime endTime;
  String? id;

  factory Priode.fromJson(Map<String?, dynamic> json) => Priode(
        priode_number: json["priode_number"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        id: json["_id"],
      );

  Map<String?, dynamic> toJson() => {
        "priode_number": priode_number.toString(),
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "_id": id,
      };
}
