import 'package:table/models/Account_models.dart';

class RequestModel {
  String? message;
  int? count;
  List<AccountModels>? allRequest;

  RequestModel({
    required this.message,
    this.count = 0,
    this.allRequest = const [],
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'] ?? 0;
    allRequest = [];
    if (json['allRequest'] != null) {
      json['allRequest'].forEach((requestData) {
        allRequest?.add(AccountModels.fromJson(requestData));
      });
    }
  }
}
