// ignore_for_file: prefer_collection_literals

import '../../ui/bottom_items/Account/models/account_models.dart';

class AllMember {
  String? message;
  int? count;
  List<AccountModels>? members;

  AllMember({this.message, this.count, this.members});

  AllMember.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['members'] != null) {
      members = <AccountModels>[];
      json['members'].forEach((v) {
        members!.add(AccountModels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['count'] = count;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
