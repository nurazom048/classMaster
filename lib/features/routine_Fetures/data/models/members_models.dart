import 'dart:convert';

class RoutineMembersModel {
  String message;
  int currentPage;
  int totalPages;
  int totalCount;
  List<Member> members;

  RoutineMembersModel({
    required this.message,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.members,
  });

  factory RoutineMembersModel.fromRawJson(String str) =>
      RoutineMembersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoutineMembersModel.fromJson(Map<String, dynamic> json) =>
      RoutineMembersModel(
        message: json["message"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalCount: json["totalCount"],
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalCount": totalCount,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };

  RoutineMembersModel copyWith({
    String? message,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    List<Member>? members,
  }) {
    return RoutineMembersModel(
      message: message ?? this.message,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      members: members ?? this.members,
    );
  }
}

class Member {
  String id;
  String username;
  String name;
  String? image;
  bool notificationOn;
  bool captain;
  bool owner;

  Member({
    required this.id,
    required this.username,
    required this.name,
    this.image,
    required this.notificationOn,
    required this.captain,
    required this.owner,
  });

  factory Member.fromRawJson(String str) => Member.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        image: json["image"],
        notificationOn: json["notificationOn"],
        captain: json["captain"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "name": name,
        "image": image,
        "notificationOn": notificationOn,
        "captain": captain,
        "owner": owner,
      };

  Member copyWith({
    String? id,
    String? username,
    String? name,
    String? image,
    bool? notificationOn,
    bool? captain,
    bool? owner,
  }) {
    return Member(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      image: image ?? this.image,
      notificationOn: notificationOn ?? this.notificationOn,
      captain: captain ?? this.captain,
      owner: owner ?? this.owner,
    );
  }
}
