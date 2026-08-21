import 'dart:convert';
import 'class_model.dart';
import 'weekday_model.dart';
import '../../presentation/widgets/static_widgets/set_schedule_section.dart';

FindClass findClassFromJson(String str) => FindClass.fromJson(json.decode(str));

class FindClass {
  String message;
  ClasssModel classes;
  List<Weekday> weekdays;
  List<ClassScheduleItem> schedules;

  FindClass({
    required this.message,
    required this.classes,
    required this.weekdays,
    required this.schedules,
  });

  factory FindClass.fromJson(Map<String, dynamic> json) => FindClass(
    message: json["message"] ?? "",
    classes: ClasssModel.fromJson(json["classes"]),
    weekdays:
        json["weekdays"] is List
            ? List<Weekday>.from(
              json["weekdays"].map((x) => Weekday.fromJson(x)),
            )
            : [],
    schedules:
        json["schedules"] is List
            ? List<ClassScheduleItem>.from(
              json["schedules"].map((x) => ClassScheduleItem.fromJson(x)),
            )
            : (json["weekdays"] is List
                ? List<ClassScheduleItem>.from(
                  json["weekdays"].map((x) => ClassScheduleItem.fromJson(x)),
                )
                : []),
  );
}
