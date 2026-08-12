import 'dart:convert';
import '../../presentation/utils/popup.dart';
import 'class_model.dart';
import 'weekday_model.dart';

FindClass findClassFromJson(String str) => FindClass.fromJson(json.decode(str));

class FindClass {
  String message;
  ClasssModel classes;
  List<Weekday> weekdays;

  FindClass({
    required this.message,
    required this.classes,
    required this.weekdays,
  });

  factory FindClass.fromJson(Map<String, dynamic> json) => FindClass(
    message: json["message"] ?? "",
    classes: ClasssModel.fromJson(json["classes"]),
    weekdays:
        json["weekdays"] is List
            ? List<Weekday>.from(
              json["weekdays"].map((x) => Weekday.fromJson(x)),
            )
            : [], // Return empty list if weekdays is not a list
  );
}
