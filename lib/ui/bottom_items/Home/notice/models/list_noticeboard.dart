import 'dart:convert';

ListOfNoticeBoard listOfNoticeBoardFromJson(String str) =>
    ListOfNoticeBoard.fromJson(json.decode(str));

String listOfNoticeBoardToJson(ListOfNoticeBoard data) =>
    json.encode(data.toJson());

class ListOfNoticeBoard {
  String message;
  List<Notice> noticeBoard;

  ListOfNoticeBoard({
    required this.message,
    required this.noticeBoard,
  });

  factory ListOfNoticeBoard.fromJson(Map<String, dynamic> json) =>
      ListOfNoticeBoard(
        message: json["message"],
        noticeBoard:
            List<Notice>.from(json["notices"].map((x) => Notice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "notices": List<dynamic>.from(noticeBoard.map((x) => x.toJson())),
      };
}

class Notice {
  String id;
  Owner owner;
  String name;

  Notice({
    required this.id,
    required this.owner,
    required this.name,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["_id"],
        owner: Owner.fromJson(json["owner"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "owner": owner.toJson(),
        "name": name,
      };
}

class Owner {
  String id;
  String username;
  String name;
  String image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "name": name,
        "image": image,
      };
}
