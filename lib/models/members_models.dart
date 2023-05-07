import 'package:table/ui/bottom_items/Account/models/account_models.dart';

class MembersModel {
  String? message;
  int? count;
  List<AccountModels>? members;

  MembersModel({
    required this.message,
    this.count = 0,
    this.members = const [],
  });

  MembersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'] ?? 0;
    members = [];
    if (json['members'] != null) {
      json['members'].forEach((requestData) {
        members?.add(AccountModels.fromJson(requestData));
      });
    }
  }
}
