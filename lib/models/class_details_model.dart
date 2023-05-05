// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:table/ui/bottom_items/Account/models/Account_models.dart';

NewClassDetailsModel newClassDetailsModelFromJson(String str) =>
    NewClassDetailsModel.fromJson(json.decode(str));

String newClassDetailsModelToJson(NewClassDetailsModel data) =>
    json.encode(data.toJson());

class NewClassDetailsModel {
  String id;
  String rutinName;
  List<Priode> priodes;
  Classes classes;
  AccountModels owner;

  NewClassDetailsModel({
    required this.id,
    required this.rutinName,
    required this.priodes,
    required this.classes,
    required this.owner,
  });

  factory NewClassDetailsModel.fromJson(Map<String, dynamic> json) =>
      NewClassDetailsModel(
        id: json["_id"],
        rutinName: json["rutin_name"],
        priodes:
            List<Priode>.from(json["priodes"].map((x) => Priode.fromJson(x))),
        classes: Classes.fromJson(json["Classes"] ?? {}),
        owner: AccountModels.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rutin_name": rutinName,
        "priodes": List<dynamic>.from(priodes.map((x) => x.toJson())),
        "owner": owner.toJson(),
      };
}

class Classes {
  List<Day> allClass;
  List<Day> sunday;
  List<Day> monday;
  List<Day> tuesday;
  List<Day> wednesday;
  List<Day> thursday;
  List<Day> friday;
  List<Day> saturday;

  Classes({
    required this.allClass,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  factory Classes.fromJson(Map<String, dynamic> json) => Classes(
        allClass:
            List<Day>.from(json["allClass"]?.map((x) => Day.fromJson(x)) ?? []),
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
}

class Day {
  String room;
  String id;
  String routineId;
  ClassId classId;
  int num;
  int start;
  int end;
  DateTime startTime;
  DateTime endTime;

  Day({
    required this.room,
    required this.id,
    required this.routineId,
    required this.classId,
    required this.num,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        room: json["room"],
        id: json["_id"],
        routineId: json["routine_id"],
        classId: ClassId.fromJson(json["class_id"]),
        num: json["num"],
        start: json["start"],
        end: json["end"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "room": room,
        "_id": id,
        "routine_id": routineId,
        "class_id": classId.toJson(),
        "num": num,
        "start": start,
        "end": end,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}

class ClassId {
  String id;
  String name;
  String instuctorName;
  String? room;
  String subjectcode;
  String rutinId;

  ClassId({
    required this.id,
    required this.name,
    required this.instuctorName,
    this.room,
    required this.subjectcode,
    required this.rutinId,
  });

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
        name: json["name"],
        instuctorName: json["instuctor_name"],
        room: json["room"],
        subjectcode: json["subjectcode"],
        rutinId: json["rutin_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "room": room,
        "subjectcode": subjectcode,
        "rutin_id": rutinId,
      };
}

class Priode {
  String id;
  int priodeNumber;
  DateTime startTime;
  DateTime endTime;
  String rutinId;

  Priode({
    required this.id,
    required this.priodeNumber,
    required this.startTime,
    required this.endTime,
    required this.rutinId,
  });

  factory Priode.fromJson(Map<String, dynamic> json) => Priode(
        id: json["_id"],
        priodeNumber: json["priode_number"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        rutinId: json["rutin_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "priode_number": priodeNumber,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "rutin_id": rutinId,
      };
}
