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
  String text;
  List<String> imageLinks;
  DateTime createdAt;
  String routineId;
  ClassDetail classDetail;
  Owner owner;

  Summary({
    required this.id,
    required this.text,
    required this.imageLinks,
    required this.createdAt,
    required this.routineId,
    required this.classDetail,
    required this.owner,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'],
      text: json['text'],
      imageLinks: List<String>.from(json['imageLinks']),
      createdAt: DateTime.parse(json['createdAt']),
      routineId: json['routineId'],
      classDetail: ClassDetail.fromJson(json['class']),
      owner: Owner.fromJson(json['owner']),
    );
  }
}

class ClassDetail {
  String id;
  String name;
  String instructorName;

  ClassDetail({
    required this.id,
    required this.name,
    required this.instructorName,
  });

  factory ClassDetail.fromJson(Map<String, dynamic> json) {
    return ClassDetail(
      id: json['id'],
      name: json['name'],
      instructorName: json['instructorName'],
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
