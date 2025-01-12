class ClassModel {
  String className;
  String instructorName;
  String subjectCode;
  String roomNumber;
  DateTime startTime;
  DateTime endTime;
  String weekday;

  ClassModel({
    required this.className,
    required this.instructorName,
    required this.subjectCode,
    required this.roomNumber,
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
    String? weekday,
  }) {
    return ClassModel(
      className: className ?? this.className,
      instructorName: instructorName ?? this.instructorName,
      subjectCode: subjectCode ?? this.subjectCode,
      roomNumber: roomNumber ?? this.roomNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      weekday: weekday ?? this.weekday,
    );
  }
}

class ClassModelUpdate {
  String className;
  String instructorName;
  String subjectCode;
  String roomNumber;

  ClassModelUpdate({
    required this.className,
    required this.instructorName,
    required this.subjectCode,
    required this.roomNumber,
  });
}
