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
  Owner owner;
  String text;
  List<String> imageLinks;
  String routineId;
  String classId;
  List<String> imageUrls;

  Summary({
    required this.id,
    required this.owner,
    required this.text,
    required this.imageLinks,
    required this.routineId,
    required this.classId,
    required this.imageUrls,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        id: json['_id'],
        owner: Owner.fromJson(json['ownerId']),
        text: json['text'],
        imageLinks: List<String>.from(json['imageLinks']),
        routineId: json['routineId'],
        classId: json['classId'],
        imageUrls: List<String>.from(json['imageUrls']),
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'imageLinks': imageLinks,
        'classId': classId,
        'imageUrls': imageUrls,
      };
}

class Owner {
  String id;
  String username;
  String name;
  String image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
    );
  }
}
