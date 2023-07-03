import 'dart:convert';

class RoutineMembersModel {
  String message;
  int count;
  List<Member> members;

  RoutineMembersModel({
    required this.message,
    required this.count,
    required this.members,
  });

  factory RoutineMembersModel.fromRawJson(String str) =>
      RoutineMembersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoutineMembersModel.fromJson(Map<String, dynamic> json) =>
      RoutineMembersModel(
        message: json["message"],
        count: json["count"],
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "count": count,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
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
        id: json["_id"],
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
}
