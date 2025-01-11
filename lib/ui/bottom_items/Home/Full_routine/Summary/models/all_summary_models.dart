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
      summaries: (json['summaries'] as List<dynamic>)
          .map((summary) => Summary.fromJson(summary))
          .toList(),
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
  Owner ownerId;
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
      id: json['id'],
      ownerId: Owner.fromJson(json['owner']),
      text: json['text'],
      imageLinks: List<String>.from(json['imageLinks']),
      routineId: json['routineId'],
      classId: json['classId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Owner {
  String id;
  String username;
  String name;
  String? image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
    );
  }
}
