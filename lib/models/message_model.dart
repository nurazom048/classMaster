// ignore_for_file: prefer_null_aware_operators

class Message {
  String message;
  bool? save;
  String? activeStatus;
  bool? notificationOff;
  bool? notificationOn;
  String? routineID;
  String? routineName;
  String? owenerName;
  String? email;

  Message({
    required this.message,
    this.save,
    this.activeStatus,
    this.notificationOff,
    this.notificationOn,
    this.routineID,
    this.routineName,
    this.owenerName,
    this.email,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      save: json['save'],
      activeStatus:
          json['activeStatus'] != null ? json['activeStatus'].toString() : null,
      notificationOff: json['notification_Off'] ?? false,
      notificationOn: json['notificationOn'] ?? false,
      routineID: json['routineID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
