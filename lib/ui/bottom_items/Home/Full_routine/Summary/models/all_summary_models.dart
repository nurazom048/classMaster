class AllSummaryModel {
  String message;
  List<Summary> summaries;
  int currentPage;
  int totalPages;
  int totalCount;

  AllSummaryModel({
    required this.message,
    required this.summaries,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory AllSummaryModel.fromJson(Map<String, dynamic> json) {
    return AllSummaryModel(
      message: json['message'],
      summaries: List<Summary>.from(
          json['summaries'].map((summary) => Summary.fromJson(summary))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
    );
  }

  AllSummaryModel copyWith({
    String? message,
    List<Summary>? summaries,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return AllSummaryModel(
      message: message ?? this.message,
      summaries: summaries ?? this.summaries,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class Summary {
  String id;
  OwnerId ownerId;
  String text;
  List<String> imageLinks;
  String routineId;
  String classId;
  DateTime createdAt;

  Summary({
    required this.id,
    required this.ownerId,
    required this.text,
    required this.imageLinks,
    required this.routineId,
    required this.classId,
    required this.createdAt,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['_id'],
      ownerId: OwnerId.fromJson(json['ownerId']),
      text: json['text'],
      imageLinks: List<String>.from(json['imageLinks']),
      routineId: json['routineId'],
      classId: json['classId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OwnerId {
  String id;
  String username;
  String name;
  String? image;

  OwnerId({
    required this.id,
    required this.username,
    required this.name,
    this.image,
  });

  factory OwnerId.fromJson(Map<String, dynamic> json) {
    return OwnerId(
      id: json['_id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
    );
  }
}
