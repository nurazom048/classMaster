class NoticeBoardListModel {
  final String message;
  final List<NoticeBoard> noticeBoards;

  NoticeBoardListModel({
    required this.message,
    required this.noticeBoards,
  });

  factory NoticeBoardListModel.fromJson(Map<String, dynamic> json) {
    return NoticeBoardListModel(
      message: json['message'] ?? "",
      noticeBoards: List<NoticeBoard>.from(
          json['noticeBoards'].map((x) => NoticeBoard.fromJson(x))),
    );
  }
}

class NoticeBoard {
  final String id;
  final Owner owner;
  final String name;

  NoticeBoard({
    required this.id,
    required this.owner,
    required this.name,
  });

  factory NoticeBoard.fromJson(Map<String, dynamic> json) {
    return NoticeBoard(
      id: json['_id'] ?? "",
      owner: Owner.fromJson(json['owner']),
      name: json['name'] ?? "",
    );
  }
}

class Owner {
  final String id;
  final String username;
  final String name;
  final String image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'] ?? "",
      username: json['username'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }
}
