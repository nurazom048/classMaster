class Notice {
  String id;
  String contentName;
  List<Pdf> pdf;
  String description;
  NoticeBoard noticeBoard;
  String visibility;
  String time;

  Notice({
    required this.id,
    required this.contentName,
    required this.pdf,
    required this.description,
    required this.noticeBoard,
    required this.visibility,
    required this.time,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['_id'],
      contentName: json['content_name'],
      pdf: List<Pdf>.from(json['pdf'].map((pdf) => Pdf.fromJson(pdf))),
      description: json['description'],
      noticeBoard: NoticeBoard.fromJson(json['noticeBoard']),
      visibility: json['visibility'],
      time: json['time'],
    );
  }
}

class Pdf {
  String url;
  String id;

  Pdf({
    required this.url,
    required this.id,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      url: json['url'],
      id: json['_id'],
    );
  }
}

class NoticeBoard {
  String id;
  Owner owner;
  String name;

  NoticeBoard({
    required this.id,
    required this.owner,
    required this.name,
  });

  factory NoticeBoard.fromJson(Map<String, dynamic> json) {
    return NoticeBoard(
      id: json['_id'],
      owner: Owner.fromJson(json['owner']),
      name: json['name'],
    );
  }
}

class Owner {
  String id;
  String username;
  String name;

  Owner({
    required this.id,
    required this.username,
    required this.name,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      username: json['username'],
      name: json['name'],
    );
  }
}

class NoticesResponse {
  String message;
  List<Notice> notices;
  int currentPage;
  int totalPages;

  NoticesResponse({
    required this.message,
    required this.notices,
    required this.currentPage,
    required this.totalPages,
  });

  factory NoticesResponse.fromJson(Map<String, dynamic> json) {
    return NoticesResponse(
      message: json['message'],
      notices: List<Notice>.from(
          json['notices'].map((notice) => Notice.fromJson(notice))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}
