import 'package:table/ui/bottom_items/Account/models/Account_models.dart';

import 'dart:convert';

SeeAllRequestModel seeAllRequestModelFromJson(String str) =>
    SeeAllRequestModel.fromJson(json.decode(str));

class SeeAllRequestModel {
  SeeAllRequestModel({
    required this.message,
    required this.count,
    required this.listAccounts,
  });

  String message;
  int count;
  List<AccountModels> listAccounts;

  factory SeeAllRequestModel.fromJson(Map<String, dynamic> json) =>
      SeeAllRequestModel(
        message: json["message"],
        count: json["count"],
        listAccounts: List<AccountModels>.from(
            json["allRequest"].map((x) => AccountModels.fromJson(x))),
      );
}
