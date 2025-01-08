import 'dart:convert';

import 'package:classmate/ui/bottom_items/Collection%20Fetures/models/account_models.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/utils/popup.dart';

AllClassesResponse allClassesResponseFromJson(String str) =>
    AllClassesResponse.fromJson(json.decode(str));

String allClassesResponseToJson(AllClassesResponse data) =>
    json.encode(data.toJson());

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

  Map<String, dynamic> toJson() {
    return {
      'allClass': allClass.map((e) => e.toJson()).toList(),
      'weekdayClasses': weekdayClasses.toJson(),
      'owner': owner.toJson(),
    };
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

  Map<String, dynamic> toJson() => {
        "sun": List<dynamic>.from(sunday.map((x) => x.toJson())),
        "mon": List<dynamic>.from(monday.map((x) => x.toJson())),
        "tue": List<dynamic>.from(tuesday.map((x) => x.toJson())),
        "wed": List<dynamic>.from(wednesday.map((x) => x.toJson())),
        "thu": List<dynamic>.from(thursday.map((x) => x.toJson())),
        "fri": List<dynamic>.from(friday.map((x) => x.toJson())),
        "sat": List<dynamic>.from(saturday.map((x) => x.toJson())),
      };
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

  Map<String, dynamic> toJson() => {
        "room": room,
        "id": id,
        "routineId": routineId,
        "name": name,
        "instructorName": instructorName,
        "subjectCode": subjectCode,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "weekdays": weekdays.map((e) => e.toJson()).toList(),
      };
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


// NewClassDetailsModel newClassDetailsModelFromJson(String str) =>
//     NewClassDetailsModel.fromJson(json.decode(str));

// String newClassDetailsModelToJson(NewClassDetailsModel data) =>
//     json.encode(data.toJson());

// class NewClassDetailsModel {
//   List<AllClass> allClass;
//   Classes classes;
//   AccountModels owner;

//   NewClassDetailsModel({
//     required this.classes,
//     required this.owner,
//     required this.allClass,
//   });

//   factory NewClassDetailsModel.fromJson(Map<String, dynamic> json) =>
//       NewClassDetailsModel(
//         classes: Classes.fromJson(json["Classes"] ?? {}),
//         owner: AccountModels.fromJson(json["owner"]),
//         allClass: List<AllClass>.from(
//             json["AllClass"].map((x) => AllClass.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "Classes": classes.toJson(),
//         "owner": owner.toJson(),
//         "AllClass": List<dynamic>.from(allClass.map((x) => x.toJson())),
//       };
// }

// class Classes {
//   List<Day> sunday;
//   List<Day> monday;
//   List<Day> tuesday;
//   List<Day> wednesday;
//   List<Day> thursday;
//   List<Day> friday;
//   List<Day> saturday;

//   Classes({
//     required this.sunday,
//     required this.monday,
//     required this.tuesday,
//     required this.wednesday,
//     required this.thursday,
//     required this.friday,
//     required this.saturday,
//   });

//   factory Classes.fromJson(Map<String, dynamic> json) => Classes(
//         sunday:
//             List<Day>.from(json["Sunday"]?.map((x) => Day.fromJson(x)) ?? []),
//         monday:
//             List<Day>.from(json["Monday"]?.map((x) => Day.fromJson(x)) ?? []),
//         tuesday:
//             List<Day>.from(json["Tuesday"]?.map((x) => Day.fromJson(x)) ?? []),
//         wednesday: List<Day>.from(
//             json["Wednesday"]?.map((x) => Day.fromJson(x)) ?? []),
//         thursday:
//             List<Day>.from(json["Thursday"]?.map((x) => Day.fromJson(x)) ?? []),
//         friday:
//             List<Day>.from(json["Friday"]?.map((x) => Day.fromJson(x)) ?? []),
//         saturday:
//             List<Day>.from(json["Saturday"]?.map((x) => Day.fromJson(x)) ?? []),
//       );

//   Map<String, dynamic> toJson() => {
//         "Sunday": List<dynamic>.from(sunday.map((x) => x.toJson())),
//         "Monday": List<dynamic>.from(monday.map((x) => x.toJson())),
//         "Tuesday": List<dynamic>.from(tuesday.map((x) => x.toJson())),
//         "Wednesday": List<dynamic>.from(wednesday.map((x) => x.toJson())),
//         "Thursday": List<dynamic>.from(thursday.map((x) => x.toJson())),
//         "Friday": List<dynamic>.from(friday.map((x) => x.toJson())),
//         "Saturday": List<dynamic>.from(saturday.map((x) => x.toJson())),
//       };
// }

// class Day {
//   String room;
//   String id;
//   String routineId;
//   ClassId classId;
//   int num;
//   DateTime startTime;
//   DateTime endTime;

//   Day({
//     required this.room,
//     required this.id,
//     required this.routineId,
//     required this.classId,
//     required this.num,
//     required this.startTime,
//     required this.endTime,
//   });

//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//         room: json["room"],
//         id: json["_id"],
//         routineId: json["routine_id"],
//         classId: ClassId.fromJson(json["class_id"]),
//         num: json["num"],
//         startTime: DateTime.parse(endMaker(json["start_time"])),
//         endTime: DateTime.parse(endMaker(json["end_time"])),
//       );

//   Map<String, dynamic> toJson() => {
//         "room": room,
//         "_id": id,
//         "routine_id": routineId,
//         "class_id": classId.toJson(),
//         "num": num,
//         "start_time": endMaker(startTime.toIso8601String().toString()),
//         "end_time": endMaker(endTime.toIso8601String().toString()),
//       };
// }

// class ClassId {
//   String id;
//   String name;
//   String instuctorName;
//   String? room;
//   String subjectcode;
//   String routineId;

//   ClassId({
//     required this.id,
//     required this.name,
//     required this.instuctorName,
//     this.room,
//     required this.subjectcode,
//     required this.routineId,
//   });

//   factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
//         id: json["_id"],
//         name: json["name"],
//         instuctorName: json["instuctor_name"],
//         room: json["room"],
//         subjectcode: json["subjectcode"],
//         routineId: json["routine_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "instuctor_name": instuctorName,
//         "room": room,
//         "subjectcode": subjectcode,
//         "routine_id": routineId,
//       };
// }

// class AllClass {
//   String id;
//   String name;
//   String instuctorName;
//   String subjectcode;
//   List<String> weekday;
//   String routineId;
//   int v;

//   AllClass({
//     required this.id,
//     required this.name,
//     required this.instuctorName,
//     required this.subjectcode,
//     required this.weekday,
//     required this.routineId,
//     required this.v,
//   });

//   factory AllClass.fromJson(Map<String, dynamic> json) => AllClass(
//         id: json["_id"],
//         name: json["name"],
//         instuctorName: json["instuctor_name"],
//         subjectcode: json["subjectcode"],
//         weekday: List<String>.from(json["weekday"].map((x) => x)),
//         routineId: json["routine_id"],
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "name": name,
//         "instuctor_name": instuctorName,
//         "subjectcode": subjectcode,
//         "weekday": List<dynamic>.from(weekday.map((x) => x)),
//         "routine_id": routineId,
//         "__v": v,
//       };
// }
