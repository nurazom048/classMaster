// ignore_for_file: prefer_null_aware_operators

class Message {
  String message;
  bool? save;
  String? activeStatus;
  bool? notificationOff;
  bool? notificationOn;
  String? routineID;
  String? routineName;
  String? ownerName;
  String? email;
  PendingAccount? pendigAccount;
  String? unverifiedEmail;

  Message({
    required this.message,
    this.save,
    this.activeStatus,
    this.notificationOff,
    this.notificationOn,
    this.routineID,
    this.routineName,
    this.ownerName,
    this.email,
    this.pendigAccount,
    this.unverifiedEmail,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        message: json['message'],
        save: json['save'],
        activeStatus: json['activeStatus'] != null
            ? json['activeStatus'].toString()
            : null,
        notificationOff: json['notification_Off'] ?? false,
        notificationOn: json['notificationOn'],
        routineID: json['routineID'] ?? '',
        pendigAccount: json['pendigAccount'] == null
            ? null
            : PendingAccount.fromJson(json['pendigAccount']),
        unverifiedEmail: json['email']);
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}

class PendingAccount {
  String id;
  bool isAccept;
  String username;
  // ignore: non_constant_identifier_names
  String EIIN;
  String name;
  String contractInfo;
  String email;
  String password;
  String accountType;
  DateTime sendTime;

  PendingAccount({
    required this.id,
    required this.isAccept,
    required this.username,
    // ignore: non_constant_identifier_names
    required this.EIIN,
    required this.name,
    required this.contractInfo,
    required this.email,
    required this.password,
    required this.accountType,
    required this.sendTime,
  });

  factory PendingAccount.fromJson(Map<String, dynamic> json) {
    return PendingAccount(
      id: json['_id'],
      isAccept: json['isAccept'],
      username: json['username'],
      EIIN: json['EIIN'],
      name: json['name'],
      contractInfo: json['contractInfo'],
      email: json['email'],
      password: json['password'],
      accountType: json['account_type'],
      sendTime: DateTime.parse(json['sendTime']),
    );
  }
}
