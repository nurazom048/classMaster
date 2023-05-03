class AllSummaryModel {
  String message;
  List<Summary> summaries;

  AllSummaryModel({
    required this.message,
    required this.summaries,
  });

  factory AllSummaryModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> summaryList = json['summaries'];
    List<Summary> summaries =
        summaryList.map((s) => Summary.fromJson(s)).toList();

    return AllSummaryModel(
      message: json['message'],
      summaries: summaries,
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
  List<String> imageUrls;

  Summary({
    required this.id,
    required this.ownerId,
    required this.text,
    required this.imageLinks,
    required this.routineId,
    required this.classId,
    required this.imageUrls,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    List<dynamic> imageLinkList = json['imageLinks'];
    List<String> imageLinks =
        imageLinkList.map((link) => link.toString()).toList();

    List<dynamic> imageUrlList = json['imageUrls'];
    List<String> imageUrls = imageUrlList.map((url) => url.toString()).toList();

    return Summary(
      id: json['_id'],
      ownerId: OwnerId.fromJson(json['ownerId']),
      text: json['text'],
      imageLinks: imageLinks,
      routineId: json['routineId'],
      classId: json['classId'],
      imageUrls: imageUrls,
    );
  }
}

class OwnerId {
  String id;
  String username;
  String name;
  String image;

  OwnerId({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
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
