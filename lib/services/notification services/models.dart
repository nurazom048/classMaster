class AllClassForNotification {
  List<ClassForNotification> allClasses;

  AllClassForNotification({required this.allClasses});

  factory AllClassForNotification.fromJson(Map<String, dynamic> json) {
    final List<dynamic> classList = json['allClassForNotification'];
    final List<ClassForNotification> classes = classList
        .map((classJson) => ClassForNotification.fromJson(classJson))
        .toList();

    return AllClassForNotification(allClasses: classes);
  }
}

class ClassForNotification {
  String id;
  String routineId;
  ClassId classId;
  String room;
  int num;
  DateTime startTime;
  DateTime endTime;

  ClassForNotification({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.num,
    required this.startTime,
    required this.endTime,
  });

  factory ClassForNotification.fromJson(Map<String, dynamic> json) {
    return ClassForNotification(
      id: json['_id'],
      routineId: json['routine_id'],
      classId: ClassId.fromJson(json['class_id']),
      room: json['room'],
      num: json['num'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}

class ClassId {
  String id;
  String name;
  String instructorName;
  String subjectCode;
  String routineId;
  int v;

  ClassId({
    required this.id,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
    required this.routineId,
    required this.v,
  });

  factory ClassId.fromJson(Map<String, dynamic> json) {
    return ClassId(
      id: json['_id'],
      name: json['name'],
      instructorName: json['instuctor_name'],
      subjectCode: json['subjectcode'],
      routineId: json['routine_id'],
      v: json['__v'],
    );
  }
}
