class FindClass {
  Classs classs;
  List<Weekday> weekdays;

  FindClass({required this.classs, required this.weekdays});

  factory FindClass.fromJson(Map<String, dynamic> json) {
    return FindClass(
      classs: Classs.fromJson(json['classs']),
      weekdays: List<Weekday>.from(
          json['weekdays'].map((weekday) => Weekday.fromJson(weekday))),
    );
  }
}

class Classs {
  String id;
  String name;
  String instuctorName;
  String room;
  String subjectCode;
  String rutinId;
  int v;

  Classs(
      {required this.id,
      required this.name,
      required this.instuctorName,
      required this.room,
      required this.subjectCode,
      required this.rutinId,
      required this.v});

  factory Classs.fromJson(Map<String, dynamic> json) {
    return Classs(
      id: json['_id'],
      name: json['name'],
      instuctorName: json['instuctor_name'],
      room: json['room'],
      subjectCode: json['subjectcode'],
      rutinId: json['rutin_id'],
      v: json['__v'],
    );
  }
}

class Weekday {
  String? id;
  String routineId;
  String classId;
  int num;
  int start;
  int end;
  int v;

  Weekday(
      {this.id,
      required this.routineId,
      required this.classId,
      required this.num,
      required this.start,
      required this.end,
      required this.v});

  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      id: json['_id'],
      routineId: json['routine_id'],
      classId: json['class_id'],
      num: json['num'],
      start: json['start'],
      end: json['end'],
      v: json['__v'],
    );
  }
}
