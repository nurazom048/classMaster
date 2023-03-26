class ClassModel {
  String className;
  String instructorName;
  String subjectCode;
  String roomNumber;
  num startingPeriod;
  num endingPeriod;
  DateTime startTime;
  DateTime endTime;
  int weekday;

  ClassModel({
    required this.className,
    required this.instructorName,
    required this.subjectCode,
    required this.roomNumber,
    required this.startingPeriod,
    required this.endingPeriod,
    required this.startTime,
    required this.endTime,
    required this.weekday,
  });

  ClassModel copyWith({
    String? className,
    String? instructorName,
    String? subjectCode,
    String? roomNumber,
    num? startingPeriod,
    num? endingPeriod,
    DateTime? startTime,
    DateTime? endTime,
    int? weekday,
  }) {
    return ClassModel(
      className: className ?? this.className,
      instructorName: instructorName ?? this.instructorName,
      subjectCode: subjectCode ?? this.subjectCode,
      roomNumber: roomNumber ?? this.roomNumber,
      startingPeriod: startingPeriod ?? this.startingPeriod,
      endingPeriod: endingPeriod ?? this.endingPeriod,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      weekday: weekday ?? this.weekday,
    );
  }
}
