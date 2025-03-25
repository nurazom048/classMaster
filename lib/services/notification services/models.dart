class ClassNotificationResponse {
  List<Weekday> allClassForNotification;

  ClassNotificationResponse({required this.allClassForNotification});

  factory ClassNotificationResponse.fromJson(Map<String, dynamic> json) =>
      ClassNotificationResponse(
        allClassForNotification: List<Weekday>.from(
            json["allClassForNotification"].map((x) => Weekday.fromJson(x))),
      );
}

class Weekday {
  String id;
  String routineId;
  String classId;
  String room;
  String day;
  DateTime startTime;
  DateTime endTime;
  DateTime createdAt;
  DateTime updatedAt;
  ClassDetails classDetails;

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
    required this.classDetails,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
        id: json["id"],
        routineId: json["routineId"],
        classId: json["classId"],
        room: json["room"],
        day: json["Day"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        classDetails: ClassDetails.fromJson(json["class"]),
      );
}

class ClassDetails {
  String id;
  String name;
  String instructorName;
  String subjectCode;

  ClassDetails({
    required this.id,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) => ClassDetails(
        id: json["id"],
        name: json["name"],
        instructorName: json["instructorName"],
        subjectCode: json["subjectCode"],
      );
}
