import 'package:table/ui/bottom_items/Account/models/account_models.dart';

class AllSummaryModel {
  String message;
  List<Summary> summaries;

  AllSummaryModel({required this.message, required this.summaries});

  factory AllSummaryModel.fromJson(Map<String, dynamic> json) {
    return AllSummaryModel(
      message: json['message'],
      summaries: List<Summary>.from(
          json['summaries'].map((summary) => Summary.fromJson(summary))),
    );
  }
}

class Summary {
  String id;
  AccountModels? owner; // Make owner field nullable
  String? text; // Make text field nullable
  List<String> imageLinks;
  String routineId;
  String classId;
  List<String> imageUrls;
  DateTime createdAt;

  Summary({
    required this.id,
    this.owner, // Update owner field to be nullable
    this.text, // Update text field to be nullable
    required this.imageLinks,
    required this.routineId,
    required this.classId,
    required this.imageUrls,
    required this.createdAt,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        id: json['_id'],
        owner: json['ownerId'] != null
            ? AccountModels.fromJson(json['ownerId'])
            : null,
        text: json['text'],
        imageLinks: List<String>.from(json['imageLinks']),
        routineId: json['routineId'],
        classId: json['classId'],
        imageUrls: List<String>.from(json['imageUrls']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'imageLinks': imageLinks,
        'classId': classId,
        'imageUrls': imageUrls,
        'createdAt': createdAt.toIso8601String(),
      };
}
