import 'dart:convert';
import 'package:classmate/ui/bottom_nevbar_items/Collection%20Fetures/models/account_models.dart';

AllClassesResponse allClassesResponseFromJson(String str) =>
    AllClassesResponse.fromJson(json.decode(str));

class AllClassesResponse {
  final List<AllClass> allClass;
  final Classes weekdayClasses;
  final AccountModels owner;

  AllClassesResponse({
    required this.allClass,
    required this.weekdayClasses,
    required this.owner,
  });

  factory AllClassesResponse.fromJson(Map<String, dynamic> json) {
    return AllClassesResponse(
      allClass: (json['allClass'] as List)
          .map((item) => AllClass.fromJson(item))
          .toList(),
      weekdayClasses: Classes.fromJson(json['weekdayClasses']),
      owner: AccountModels.fromJson(json['owner']),
    );
  }
}

class AllClass {
  final String id;
  final String name;
  final String instructorName;
  final String subjectCode;
  final String routineId;

  AllClass({
    required this.id,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
    required this.routineId,
  });

  factory AllClass.fromJson(Map<String, dynamic> json) {
    return AllClass(
      id: json['id'],
      name: json['name'],
      instructorName: json['instructorName'],
      subjectCode: json['subjectCode'],
      routineId: json['routineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'instructorName': instructorName,
      'subjectCode': subjectCode,
      'routineId': routineId,
    };
  }
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
        sunday: List<Day>.from(json["sun"]?.map((x) => Day.fromJson(x)) ?? []),
        monday: List<Day>.from(json["mon"]?.map((x) => Day.fromJson(x)) ?? []),
        tuesday: List<Day>.from(json["tue"]?.map((x) => Day.fromJson(x)) ?? []),
        wednesday:
            List<Day>.from(json["wed"]?.map((x) => Day.fromJson(x)) ?? []),
        thursday:
            List<Day>.from(json["thu"]?.map((x) => Day.fromJson(x)) ?? []),
        friday: List<Day>.from(json["fri"]?.map((x) => Day.fromJson(x)) ?? []),
        saturday:
            List<Day>.from(json["sat"]?.map((x) => Day.fromJson(x)) ?? []),
      );
}

class Day {
  String room;
  String id;
  String routineId;
  String name;
  String instructorName;
  String subjectCode;
  DateTime startTime;
  DateTime endTime;
  DateTime createdAt;
  DateTime updatedAt;
  List<Weekday> weekdays;

  Day({
    required this.room,
    required this.id,
    required this.routineId,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.weekdays,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        room: json["room"],
        id: json["id"],
        routineId: json["routineId"],
        name: json["name"],
        instructorName: json["instructorName"],
        subjectCode: json["subjectCode"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        weekdays: (json['weekdays'] as List)
            .map((item) => Weekday.fromJson(item))
            .toList(),
      );
}

class Weekday {
  final String id;
  final String routineId;
  final String classId;
  final String room;
  final String day;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Weekday({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      id: json['id'],
      routineId: json['routineId'],
      classId: json['classId'],
      room: json['room'],
      day: json['Day'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineId': routineId,
      'classId': classId,
      'room': room,
      'day': day,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
