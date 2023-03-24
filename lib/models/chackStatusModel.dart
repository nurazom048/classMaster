class CheckStatusModel {
  final bool isOwner;
  final bool isCaptain;
  final String activeStatus;
  final bool isSave;
  final int memberCount;
  final int sentRequestCount;

  CheckStatusModel({
    required this.isOwner,
    required this.isCaptain,
    required this.activeStatus,
    required this.isSave,
    required this.memberCount,
    required this.sentRequestCount,
  });

  factory CheckStatusModel.fromJson(Map<String, dynamic> json) {
    return CheckStatusModel(
      isOwner: json['isOwner'] ?? false,
      isCaptain: json['isCaptain'] ?? false,
      activeStatus: json['activeStatus'] ?? "",
      isSave: json['isSave'] ?? false,
      memberCount: json['memberCount'] ?? 0,
      sentRequestCount: json['sentRequestCount'] ?? 0,
    );
  }

  CheckStatusModel copyWith({
    bool? isOwner,
    bool? isCaptain,
    String? activeStatus,
    bool? isSave,
    int? memberCount,
    int? sentRequestCount,
  }) {
    return CheckStatusModel(
      isOwner: isOwner ?? this.isOwner,
      isCaptain: isCaptain ?? this.isCaptain,
      activeStatus: activeStatus ?? this.activeStatus,
      isSave: isSave ?? this.isSave,
      memberCount: memberCount ?? this.memberCount,
      sentRequestCount: sentRequestCount ?? this.sentRequestCount,
    );
  }
}
