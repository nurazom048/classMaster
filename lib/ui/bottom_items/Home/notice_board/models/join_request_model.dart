import '../../../Account/models/account_models.dart';

class JoinRequestsResponseModel {
  final String message;
  final List<AccountModels> joinRequests;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  JoinRequestsResponseModel({
    required this.message,
    required this.joinRequests,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory JoinRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestsResponseModel(
      message: json['message'] ?? "",
      joinRequests: (json['joinRequests'] as List<dynamic>?)
              ?.map((item) => AccountModels.fromJson(item))
              .toList() ??
          [],
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
