import 'dart:convert';

import '../../../account_fetures/data/models/account_models.dart';
import 'weekday_model.dart' show Weekday;

AllClassesResponse allClassesResponseFromJson(String str) =>
    AllClassesResponse.fromJson(json.decode(str));

class AllClassesResponse {
  final List<AllClass> allClass;
  final Classes weekdayClasses;
  final List<ExamModel> exams;
  final String routineType;
  final AccountModels owner;
  final String? routineName;
  final dynamic about;

  AllClassesResponse({
    required this.allClass,
    required this.weekdayClasses,
    this.exams = const [],
    this.routineType = "CLASS",
    required this.owner,
    this.routineName,
    this.about,
  });

  factory AllClassesResponse.fromJson(Map<String, dynamic> json) {
    return AllClassesResponse(
      allClass:
          (json['allClass'] as List? ?? [])
              .map((item) => AllClass.fromJson(item))
              .toList(),
      weekdayClasses: json['weekdayClasses'] != null 
          ? Classes.fromJson(json['weekdayClasses']) 
          : Classes(sunday: [], monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: []),
      exams: (json['exams'] as List? ?? [])
          .map((item) => ExamModel.fromJson(item))
          .toList(),
      routineType: (json['routineType'] ?? "CLASS").toString().toUpperCase(),
      owner: json['owner'] != null ? AccountModels.fromJson(json['owner']) : AccountModels(),
      routineName: json['routineName'],
      about: json['about'],
    );
  }
}

class ExamModel {
  final String id;
  final int? model_no;
  final String name;
  final String? subjectCode;
  final double? price;
  final dynamic syllabus;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  final String routineId;

  ExamModel({
    required this.id,
    this.model_no,
    required this.name,
    this.subjectCode,
    this.price = 0,
    this.syllabus,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.routineId,
  });

  bool get isFree => price == null || price == 0;

  String? get commonSyllabus {
    dynamic sys = syllabus;
    if (sys is String && sys.trim().startsWith('{')) {
      try {
        sys = json.decode(sys);
      } catch (_) {}
    }

    if (sys is Map) {
      final val = sys['common'] ?? sys['commonSyllabus'];
      return val?.toString();
    } else if (sys is String) {
      return sys;
    }
    return null;
  }

  String? getDepartmentSyllabus(String departmentName) {
    dynamic sys = syllabus;
    if (sys is String && sys.trim().startsWith('{')) {
      try {
        sys = json.decode(sys);
      } catch (_) {}
    }

    if (sys is Map) {
      final target = departmentName.toLowerCase().trim();

      Map? depts;
      if (sys['departments'] is Map) {
        depts = sys['departments'] as Map;
      } else {
        depts = sys;
      }

      // Exact match
      for (final entry in depts.entries) {
        final keyStr = entry.key.toString().toLowerCase().trim();
        if (keyStr == target) {
          return entry.value?.toString();
        }
      }

      // Contains/Fuzzy match
      for (final entry in depts.entries) {
        final keyStr = entry.key.toString().toLowerCase().trim();
        if (keyStr.isNotEmpty && keyStr != 'common' && keyStr != 'departments' &&
            (keyStr.contains(target) || target.contains(keyStr))) {
          return entry.value?.toString();
        }
      }
    }
    return null;
  }

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    dynamic parsedSyllabus = json['syllabus'];
    if (parsedSyllabus is String && parsedSyllabus.trim().startsWith('{')) {
      try {
        parsedSyllabus = jsonDecode(parsedSyllabus);
      } catch (_) {}
    }

    return ExamModel(
      id: json['id'] ?? '',
      model_no: json['model_no'] ?? json['modelNo'],
      name: json['name'] ?? '',
      subjectCode: json['subjectCode'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0,
      syllabus: parsedSyllabus,
      date: DateTime.parse(json['date']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      room: json['room'] ?? '',
      routineId: json['routineId'] ?? '',
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
    wednesday: List<Day>.from(json["wed"]?.map((x) => Day.fromJson(x)) ?? []),
    thursday: List<Day>.from(json["thu"]?.map((x) => Day.fromJson(x)) ?? []),
    friday: List<Day>.from(json["fri"]?.map((x) => Day.fromJson(x)) ?? []),
    saturday: List<Day>.from(json["sat"]?.map((x) => Day.fromJson(x)) ?? []),
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
    weekdays:
        (json['weekdays'] as List)
            .map((item) => Weekday.fromJson(item))
            .toList(),
  );
}
