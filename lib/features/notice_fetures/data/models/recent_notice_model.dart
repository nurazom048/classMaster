import 'package:classmate/features/account_fetures/data/models/account_models.dart';

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
  }) => RecentNotice(
    message: message ?? this.message,
    notices: notices ?? this.notices,
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    totalCount: totalCount ?? this.totalCount,
  );

  factory RecentNotice.fromJson(Map<String, dynamic> json) => RecentNotice(
    message: json["message"] ?? '',
    notices: List<Notice>.from(
      (json["notices"] as List<dynamic>?)?.map(
            (x) => Notice.fromJson(x as Map<String, dynamic>),
          ) ??
          [],
    ),
    currentPage: json["currentPage"] ?? 1,
    totalPages: json["totalPages"] ?? 1,
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "notices": notices.map((x) => x.toJson()).toList(),
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalCount": totalCount,
  };
}

class Notice {
  String id;
  String title;
  String pdf;
  String? description;
  String category;
  String publisherId;
  AccountModels account;
  DateTime createdAt;
  DateTime? updatedAt;

  Notice({
    required this.id,
    required this.title,
    required this.pdf,
    this.description,
    this.category = 'notice',
    required this.publisherId,
    required this.account,
    required this.createdAt,
    this.updatedAt,
  });

  Notice copyWith({
    String? id,
    String? title,
    String? pdf,
    String? description,
    String? category,
    String? publisherId,
    AccountModels? account,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Notice(
    id: id ?? this.id,
    title: title ?? this.title,
    pdf: pdf ?? this.pdf,
    description: description ?? this.description,
    category: category ?? this.category,
    publisherId: publisherId ?? this.publisherId,
    account: account ?? this.account,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json["id"] ?? '',
    title: json["title"] ?? '',
    pdf: json["pdf"] ?? '',
    description: json["description"],
    category: json["category"] ?? 'notice',
    publisherId: json["publisherId"] ?? '',
    account: AccountModels.fromJson(
      json["Account"] as Map<String, dynamic>? ?? {},
    ),
    createdAt:
        json["createdAt"] != null
            ? DateTime.parse(json["createdAt"] as String)
            : DateTime.now(),
    updatedAt:
        json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"] as String)
            : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "pdf": pdf,
    "description": description,
    "category": category,
    "publisherId": publisherId,
    "Account": account.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
