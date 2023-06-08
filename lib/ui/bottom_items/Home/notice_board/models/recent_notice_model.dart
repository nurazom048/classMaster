import 'dart:convert';

RecentNotice recentNoticeFromJson(String str) =>
    RecentNotice.fromJson(json.decode(str));

class RecentNotice {
  String message;
  List<Notice> notices;
  int currentPage;
  int totalPages;
  int totalCount;

  RecentNotice({
    required this.message,
    required this.notices,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  RecentNotice copyWith({
    String? message,
    List<Notice>? notices,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) =>
      RecentNotice(
        message: message ?? this.message,
        notices: notices ?? this.notices,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        totalCount: totalCount ?? this.totalCount,
      );

  factory RecentNotice.fromJson(Map<String, dynamic> json) => RecentNotice(
        message: json["message"],
        notices:
            List<Notice>.from(json["notices"].map((x) => Notice.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalCount: json["totalCount"],
      );
}

class Notice {
  String id;
  String contentName;
  String pdf;
  String? description;
  AcademyId academyId;
  DateTime time;

  Notice({
    required this.id,
    required this.contentName,
    required this.pdf,
    this.description,
    required this.academyId,
    required this.time,
  });

  Notice copyWith({
    String? id,
    String? contentName,
    String? pdf,
    String? description,
    AcademyId? academyId,
    DateTime? time,
  }) =>
      Notice(
        id: id ?? this.id,
        contentName: contentName ?? this.contentName,
        pdf: pdf ?? this.pdf,
        description: description ?? this.description,
        academyId: academyId ?? this.academyId,
        time: time ?? this.time,
      );

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["_id"],
        contentName: json["content_name"],
        pdf: json["pdf"] == "" ? null : json["pdf"],
        description: json["description"],
        academyId: AcademyId.fromJson(json["academyID"]),
        time: DateTime.parse(json["time"]),
      );
}

class AcademyId {
  String id;
  String username;
  String name;

  AcademyId({
    required this.id,
    required this.username,
    required this.name,
  });

  AcademyId copyWith({
    String? id,
    String? username,
    String? name,
  }) =>
      AcademyId(
        id: id ?? this.id,
        username: username ?? this.username,
        name: name ?? this.name,
      );

  factory AcademyId.fromJson(Map<String, dynamic> json) => AcademyId(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "name": name,
      };
}
