import 'package:classmate/ui/bottom_items/Home/Full_routine/utils/popup.dart';

class AllPriodeList {
  final String message;
  final List<AllPriode> priodes;

  AllPriodeList({required this.message, required this.priodes});

  factory AllPriodeList.fromJson(Map<String, dynamic> json) {
    List<dynamic> priodeList = json['priodes'];
    List<AllPriode> parsedPriodeList =
        priodeList.map((p) => AllPriode.fromJson(p)).toList();
    return AllPriodeList(
      message: json['message'],
      priodes: parsedPriodeList,
    );
  }
}

class AllPriode {
  final String id;
  final int priodeNumber;
  final DateTime startTime;
  final DateTime endTime;
  final String rutinId;
  final int v;

  AllPriode({
    required this.id,
    required this.priodeNumber,
    required this.startTime,
    required this.endTime,
    required this.rutinId,
    required this.v,
  });

  factory AllPriode.fromJson(Map<String, dynamic> json) {
    return AllPriode(
      id: json['_id'],
      priodeNumber: json['priode_number'],
      startTime: DateTime.parse(endMaker(json["start_time"])),
      endTime: DateTime.parse(endMaker(json["end_time"])),
      rutinId: json['rutin_id'],
      v: json['__v'],
    );
  }
}
