import '../../../Collection Fetures/models/account_models.dart';

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
  String title;
  String pdf;
  String? description;
  AccountModels account;
  DateTime createdAt;

  Notice({
    required this.id,
    required this.title,
    required this.pdf,
    this.description,
    required this.account,
    required this.createdAt,
  });

  Notice copyWith({
    String? id,
    String? title,
    String? pdf,
    String? description,
    AccountModels? account,
    DateTime? createdAt,
  }) =>
      Notice(
        id: id ?? this.id,
        title: title ?? this.title,
        pdf: pdf ?? this.pdf,
        description: description ?? this.description,
        account: account ?? this.account,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["id"],
        title: json["title"],
        pdf: json["pdf"],
        description: json["description"], // Null-safe handling
        account: AccountModels.fromJson(json["Account"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );
}
