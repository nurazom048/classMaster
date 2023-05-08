// class JoinRequestModel {
//   final String id;
//   final String username;
//   final String name;
//   final String image;

//   JoinRequestModel({
//     required this.id,
//     required this.username,
//     required this.name,
//     required this.image,
//   });

//   factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
//     return JoinRequestModel(
//       id: json['_id'] ?? "",
//       username: json['username'] ?? "",
//       name: json['name'] ?? "",
//       image: json['image'] ?? "",
//     );
//   }
// }

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
      joinRequests: List<AccountModels>.from(
          json['joinRequests'].map((x) => AccountModels.fromJson(x))),
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
