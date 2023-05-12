import '../../../Account/models/account_models.dart';

class AllMembersModel {
  final String message;
  final List<AccountModels> members;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  AllMembersModel({
    required this.message,
    required this.members,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory AllMembersModel.fromJson(Map<String, dynamic> json) {
    return AllMembersModel(
      message: json['message'],
      members: List<AccountModels>.from(
          json['mebers'].map((x) => AccountModels.fromJson(x))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
    );
  }
}
