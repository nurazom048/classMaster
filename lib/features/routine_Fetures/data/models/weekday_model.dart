import '../../presentation/utils/popup.dart';

class Weekday {
  dynamic id;
  String routineId;
  String classId;
  String room;
  String weekday;
  DateTime startTime;
  DateTime endTime;

  Weekday({
    required this.id,
    required this.routineId,
    required this.classId,
    required this.room,
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  factory Weekday.fromJson(Map<String, dynamic> json) => Weekday(
    id: json["id"].toString(),
    routineId: json["routineId"].toString(),
    classId: json["classId"].toString(),
    room: json["room"].toString(),
    weekday: json["Day"]?.toString() ?? "Unknown",
    startTime: DateTime.parse(endMaker(json["startTime"])),
    endTime: DateTime.parse(endMaker(json["endTime"])),
  );
}
