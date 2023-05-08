import 'dart:convert';

ListOfNoticeBoard listOfNoticeBoardFromJson(String str) =>
    ListOfNoticeBoard.fromJson(json.decode(str));

String listOfNoticeBoardToJson(ListOfNoticeBoard data) =>
    json.encode(data.toJson());

class ListOfNoticeBoard {
  String message;
  List<NoticeBoard> noticeBoards;
  int? currentPage;
  int? totalPages;

  ListOfNoticeBoard({
    required this.message,
    required this.noticeBoards,
    this.currentPage,
    this.totalPages,
  });

  factory ListOfNoticeBoard.fromJson(Map<String, dynamic> json) =>
      ListOfNoticeBoard(
        message: json["message"],
        noticeBoards: List<NoticeBoard>.from(
            json["noticeBoards"].map((x) => NoticeBoard.fromJson(x))),
        currentPage: json["currentPage"] ?? null,
        totalPages: json["totalPages"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "noticeBoards": List<dynamic>.from(noticeBoards.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}

class NoticeBoard {
  String id;
  Owner owner;
  String name;

  NoticeBoard({
    required this.id,
    required this.owner,
    required this.name,
  });

  factory NoticeBoard.fromJson(Map<String, dynamic> json) => NoticeBoard(
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
  String image;
  String? username;
  String? name;

  Owner({
    required this.id,
    required this.image,
    this.username,
    this.name,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["_id"],
        image: json["image"],
        username: json["username"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "username": username,
        "name": name,
      };
}
