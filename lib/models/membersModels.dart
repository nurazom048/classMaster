import 'package:table/models/Account_models.dart';

class MembersModel {
  String? message;
  int? count;
  List<AccountModels>? Members;

  MembersModel({
    required this.message,
    this.count = 0,
    this.Members = const [],
  });

  MembersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'] ?? 0;
    Members = [];
    if (json['members'] != null) {
      json['members'].forEach((requestData) {
        Members?.add(AccountModels.fromJson(requestData));
      });
    }
  }
}
