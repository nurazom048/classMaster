class ClassNotificationList {
  List<ClassNotification> notificationOnClasses;

  ClassNotificationList({
    required this.notificationOnClasses,
  });

  factory ClassNotificationList.fromJson(Map<String, dynamic> json) {
    return ClassNotificationList(
      notificationOnClasses: (json['notificationOnClasses'] as List<dynamic>?)
              ?.map((x) => ClassNotification.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class ClassNotification {
  String id;
  String routineId;
  ClassInfo classInfo;
  String room;
  int num;
  int start;
  int end;
  int v;
  DateTime startTime;
  DateTime endTime;

  ClassNotification({
    required this.id,
    required this.routineId,
    required this.classInfo,
    required this.room,
    required this.num,
    required this.start,
    required this.end,
    required this.v,
    required this.startTime,
    required this.endTime,
  });

  factory ClassNotification.fromJson(Map<String, dynamic> json) {
    return ClassNotification(
      id: json['_id'],
      routineId: json['routine_id'],
      classInfo: ClassInfo.fromJson(json['class_id']),
      room: json['room'],
      num: json['num'],
      start: json['start'],
      end: json['end'],
      v: json['__v'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}

class ClassInfo {
  String id;
  String name;
  String instructorName;
  String subjectCode;
  String rutinId;
  int v;

  ClassInfo({
    required this.id,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
    required this.rutinId,
    required this.v,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['_id'],
      name: json['name'],
      instructorName: json['instuctor_name'],
      subjectCode: json['subjectcode'],
      rutinId: json['rutin_id'],
      v: json['__v'],
    );
  }
}
