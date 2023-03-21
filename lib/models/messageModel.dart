class Message {
  String message;
  bool? save;

  Message({required this.message, this.save});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      save: json['save'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
