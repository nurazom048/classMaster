class CheckStatusModel {
  final bool isOwner;
  final bool isCaptain;
  final String activeStatus;
  final bool isSave;

  CheckStatusModel({
    required this.isOwner,
    required this.isCaptain,
    required this.activeStatus,
    required this.isSave,
  });

  factory CheckStatusModel.fromJson(Map<String, dynamic> json) {
    return CheckStatusModel(
      isOwner: json['isOwner'] ?? false,
      isCaptain: json['isCaptain'] ?? false,
      activeStatus: json['activeStatus'] ?? "",
      isSave: json['isSave'] ?? false,
    );
  }
}
