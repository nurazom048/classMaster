import 'dart:convert';

FindClass findClassFromJson(String str) => FindClass.fromJson(json.decode(str));

String findClassToJson(FindClass data) => json.encode(data.toJson());

class FindClass {
  String message;
  Classs classs;
  List<Weekday> weekdays;

  FindClass({
    required this.message,
    required this.classs,
    required this.weekdays,
  });

  factory FindClass.fromJson(Map<String, dynamic> json) => FindClass(
        message: json["message"],
        classs: Classs.fromJson(json["classs"]),
        weekdays: List<Weekday>.from(
            json["weekdays"].map((x) => Weekday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "classs": classs.toJson(),
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
        rutinId: json["rutin_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "instuctor_name": instuctorName,
        "subjectcode": subjectcode,
        "rutin_id": rutinId,
        "__v": v,
      };
}

class Weekday {
  String id;
  String routineId;
  String classId;
  String room;
  int num;
  int start;
  int end;
  int v;

  Weekday({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.num,
    required this.start,
    required this.end,
    required this.v,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        id: json["_id"],
        routineId: json["routine_id"],
        classId: json["class_id"],
        room: json["room"],
        num: json["num"],
        start: json["start"],
        end: json["end"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "routine_id": routineId,
        "class_id": classId,
        "room": room,
        "num": num,
        "start": start,
        "end": end,
        "__v": v,
      };
}
