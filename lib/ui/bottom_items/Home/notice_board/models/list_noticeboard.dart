import 'dart:convert';

ListOfNoticeBoard listOfNoticeBoardFromJson(String str) =>
    ListOfNoticeBoard.fromJson(json.decode(str));

class ListOfNoticeBoard {
  String message;
  List<NoticeBoard> noticeBoards;
  int currentPage;
  int totalPages;

  ListOfNoticeBoard({
    required this.message,
    required this.noticeBoards,
    required this.currentPage,
    required this.totalPages,
  });

  ListOfNoticeBoard copyWith({
    String? message,
    List<NoticeBoard>? noticeBoards,
    int? currentPage,
    int? totalPages,
  }) =>
      ListOfNoticeBoard(
        message: message ?? this.message,
        noticeBoards: noticeBoards ?? this.noticeBoards,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
      );

  factory ListOfNoticeBoard.fromJson(Map<String, dynamic> json) =>
      ListOfNoticeBoard(
        message: json["message"],
        noticeBoards: List<NoticeBoard>.from(
            json["noticeBoards"].map((x) => NoticeBoard.fromJson(x))),
        currentPage: json["currentPage"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
      );
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

  NoticeBoard copyWith({
    String? id,
    Owner? owner,
    String? name,
  }) =>
      NoticeBoard(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        name: name ?? this.name,
      );

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
  String username;
  String name;
  String image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
  });

  Owner copyWith({
    String? id,
    String? username,
    String? name,
    String? image,
  }) =>
      Owner(
        id: id ?? this.id,
        username: username ?? this.username,
        name: name ?? this.name,
        image: image ?? this.image,
      );

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
