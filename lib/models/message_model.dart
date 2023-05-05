class Message {
  String message;
  bool? save;
  String? activeStatus;

  Message({required this.message, this.save, this.activeStatus});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      save: json['save'],
      activeStatus: json['activeStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
