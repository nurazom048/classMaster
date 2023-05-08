class Message {
  String message;
  bool? save;
  String? activeStatus;
  bool? notificationOff;

  Message(
      {required this.message,
      this.save,
      this.activeStatus,
      this.notificationOff});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      save: json['save'],
      activeStatus: json['activeStatus'],
      notificationOff: json['notification_Off'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
