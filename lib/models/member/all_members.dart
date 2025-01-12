// ignore_for_file: prefer_collection_literals

import '../../ui/bottom_items/Collection Fetures/models/account_models.dart';

class AllMemberModel {
  String? message;
  int? count;
  List<AccountModels>? members;

  AllMemberModel({this.message, this.count, this.members});

  AllMemberModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['members'] != null) {
      members = <AccountModels>[];
      json['members'].forEach((v) {
        members!.add(AccountModels.fromJson(v));
      });
    }
  }
}
