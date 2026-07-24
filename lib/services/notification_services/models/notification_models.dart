class ClassNotificationResponse {
  List<WeekdayForNotificationModel> allClassForNotification;

  ClassNotificationResponse({required this.allClassForNotification});

  factory ClassNotificationResponse.fromJson(Map<String, dynamic> json) =>
      ClassNotificationResponse(
        allClassForNotification: List<WeekdayForNotificationModel>.from(
          json["allClassForNotification"].map(
            (x) => WeekdayForNotificationModel.fromJson(x),
          ),
        ),
      );
}

// ignore: camel_case_types
class WeekdayForNotificationModel {
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
  bool notificationOn;

  WeekdayForNotificationModel({
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
    this.notificationOn = true,
  });

  factory WeekdayForNotificationModel.fromJson(Map<String, dynamic> json) =>
      WeekdayForNotificationModel(
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
        notificationOn: json["notificationOn"] ?? json["isNotificationOn"] ?? json["notification_status"] ?? true,
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
