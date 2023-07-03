import '../class/find_class_model.dart';

class WeekdayList {
  final String message;
  final List<Weekday> weekdays;

  WeekdayList({
    required this.message,
    required this.weekdays,
  });

  factory WeekdayList.fromJson(Map<String, dynamic> json) {
    var list = json['weekdays'] as List;
    List<Weekday> weekdays =
        list.map((item) => Weekday.fromJson(item)).toList();

    return WeekdayList(
      message: json['message'],
      weekdays: weekdays,
    );
  }
}
