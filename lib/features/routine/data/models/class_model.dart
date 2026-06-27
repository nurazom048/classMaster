class ClasssModel {
  final String id;
  final String name;
  final String instructorName;
  final String subjectCode;
  final String routineId;

  // Room number (optional)
  final String? roomNumber;
  // Weekday (optional)
  final String? weekday;

  const ClasssModel({
    required this.id,
    required this.name,
    required this.instructorName,
    required this.subjectCode,
    required this.routineId,
    this.roomNumber,
    this.weekday,
  });

  // ---------------------------------------------------------
  // Create model from API response
  // ---------------------------------------------------------
  factory ClasssModel.fromJson(Map<String, dynamic> json) {
    return ClasssModel(
      id: json["id"]?.toString() ?? '',
      name: json["name"]?.toString() ?? '',
      instructorName: json["instructorName"]?.toString() ?? '',
      subjectCode: json["subjectCode"]?.toString() ?? '',
      routineId: json["routineId"]?.toString() ?? '',
      roomNumber: json["roomNumber"]?.toString(),
      weekday: json["weekday"]?.toString(),
    );
  }

  // ---------------------------------------------------------
  // Convert model to JSON
  // Useful for API requests
  // ---------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "instructorName": instructorName,
      "subjectCode": subjectCode,
      "routineId": routineId,
      "roomNumber": roomNumber,
      "weekday": weekday,
    };
  }

  // ---------------------------------------------------------
  // API request body for Add/Edit Class
  // Only sends fields backend actually needs
  // ---------------------------------------------------------
  Map<String, String> toRequestBody() {
    return {
      "name": name,
      "instructorName": instructorName,
      "subjectCode": subjectCode,
      "room": roomNumber ?? '',
      "weekday": weekday ?? '',
    };
  }

  // ---------------------------------------------------------
  // Create a modified copy
  // ---------------------------------------------------------
  ClasssModel copyWith({
    String? id,
    String? name,
    String? instructorName,
    String? subjectCode,
    String? routineId,
    String? roomNumber,
    String? weekday,
  }) {
    return ClasssModel(
      id: id ?? this.id,
      name: name ?? this.name,
      instructorName: instructorName ?? this.instructorName,
      subjectCode: subjectCode ?? this.subjectCode,
      routineId: routineId ?? this.routineId,
      roomNumber: roomNumber ?? this.roomNumber,
      weekday: weekday ?? this.weekday,
    );
  }
}
