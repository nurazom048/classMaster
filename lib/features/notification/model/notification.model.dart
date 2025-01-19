// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

class NotificationModel {
  List<AppNotification> notifications;
  int currentPage;
  int totalPages;

  NotificationModel({
    required this.notifications,
    required this.currentPage,
    required this.totalPages,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notifications: List<AppNotification>.from(
            json["notifications"].map((x) => AppNotification.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}

class AppNotification {
  String id;
  String title;
  String body;
  String? imageUrl;
  String type;
  DateTime createdAt;
  int v;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.createdAt,
    required this.v,
  });

  factory AppNotification.fromRawJson(String str) =>
      AppNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        imageUrl: json["imageUrl"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "imageUrl": imageUrl,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
      };
}
