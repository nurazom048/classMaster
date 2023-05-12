import 'dart:convert';

import '../notice bord/recentNotice.dart';
import 'dart:convert';

import '../notice bord/recentNotice.dart';

ListOfNoticesModel listOfNoticesModelFromJson(String str) =>
    ListOfNoticesModel.fromJson(json.decode(str));

class ListOfNoticesModel {
  String message;
  List<Notice> notices;
  int currentPage;
  int totalPages;
  int totalCount;

  ListOfNoticesModel({
    required this.message,
    required this.notices,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory ListOfNoticesModel.fromJson(Map<String, dynamic> json) =>
      ListOfNoticesModel(
        message: json["message"],
        notices:
            List<Notice>.from(json["notices"].map((x) => Notice.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalCount: json["totalCount"],
      );

  ListOfNoticesModel copyWith({
    String? message,
    List<Notice>? notices,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return ListOfNoticesModel(
      message: message ?? this.message,
      notices: notices ?? this.notices,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class Notice {
  String id;
  String contentName;
  List<Pdf> pdf;
  String description;
  NoticeBoard noticeBoard;
  String visibility;
  DateTime time;

  Notice({
    required this.id,
    required this.contentName,
    required this.pdf,
    required this.description,
    required this.noticeBoard,
    required this.visibility,
    required this.time,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["_id"],
        contentName: json["content_name"],
        pdf: List<Pdf>.from(json["pdf"].map((x) => Pdf.fromJson(x))),
        description: json["description"],
        noticeBoard: NoticeBoard.fromJson(json["noticeBoard"]),
        visibility: json["visibility"],
        time: DateTime.parse(json["time"]),
      );

  Notice copyWith({
    String? id,
    String? contentName,
    List<Pdf>? pdf,
    String? description,
    NoticeBoard? noticeBoard,
    String? visibility,
    DateTime? time,
  }) {
    return Notice(
      id: id ?? this.id,
      contentName: contentName ?? this.contentName,
      pdf: pdf ?? this.pdf,
      description: description ?? this.description,
      noticeBoard: noticeBoard ?? this.noticeBoard,
      visibility: visibility ?? this.visibility,
      time: time ?? this.time,
    );
  }
}
