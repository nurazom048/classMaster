class CreatedNoticeBoardByMe {
  String message;
  List<CreatedNoticeBoard> noticeBoards;

  CreatedNoticeBoardByMe({
    required this.message,
    required this.noticeBoards,
  });

  factory CreatedNoticeBoardByMe.fromJson(Map<String, dynamic> json) {
    return CreatedNoticeBoardByMe(
      message: json['message'],
      noticeBoards: List<CreatedNoticeBoard>.from(
          json['notices'].map((notice) => CreatedNoticeBoard.fromJson(notice))),
    );
  }
}

class CreatedNoticeBoard {
  String id;
  String owner;
  String name;

  CreatedNoticeBoard({
    required this.id,
    required this.owner,
    required this.name,
  });

  factory CreatedNoticeBoard.fromJson(Map<String, dynamic> json) {
    return CreatedNoticeBoard(
      id: json['_id'],
      owner: json['owner'],
      name: json['name'],
    );
  }
}
