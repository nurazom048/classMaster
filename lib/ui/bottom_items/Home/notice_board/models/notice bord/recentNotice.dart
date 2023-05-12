class RecentNotice {
  String message;
  List<Notice> notices;
  int currentPage;
  int totalPages;
  int totalCount;

  RecentNotice({
    required this.message,
    required this.notices,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory RecentNotice.fromJson(Map<String, dynamic> json) {
    List<Notice> notices = [];
    for (var notice in json['notices']) {
      notices.add(Notice.fromJson(notice));
    }

    return RecentNotice(
      message: json['message'],
      notices: notices,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
    );
  }

  RecentNotice copyWith({
    String? message,
    List<Notice>? notices,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return RecentNotice(
      message: message ?? this.message,
      notices: notices ?? this.notices,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class Notice {
  String id;
  String contentName;
  List<Pdf> pdf;
  String description;
  NoticeBoard noticeBoard;
  DateTime time;

  Notice({
    required this.id,
    required this.contentName,
    required this.pdf,
    required this.description,
    required this.noticeBoard,
    required this.time,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    List<Pdf> pdf = [];
    for (var pdfObj in json['pdf']) {
      pdf.add(Pdf.fromJson(pdfObj));
    }

    return Notice(
      id: json['_id'],
      contentName: json['content_name'],
      pdf: pdf,
      description: json['description'],
      noticeBoard: NoticeBoard.fromJson(json['noticeBoard']),
      time: DateTime.parse(json['time']),
    );
  }

  Notice copyWith({
    String? id,
    String? contentName,
    List<Pdf>? pdf,
    String? description,
    NoticeBoard? noticeBoard,
    DateTime? time,
  }) {
    return Notice(
      id: id ?? this.id,
      contentName: contentName ?? this.contentName,
      pdf: pdf ?? this.pdf,
      description: description ?? this.description,
      noticeBoard: noticeBoard ?? this.noticeBoard,
      time: time ?? this.time,
    );
  }
}

class Pdf {
  String url;
  String id;

  Pdf({required this.url, required this.id});

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      url: json['url'],
      id: json['_id'],
    );
  }

  Pdf copyWith({
    String? url,
    String? id,
  }) {
    return Pdf(
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}

class NoticeBoard {
  String id;
  String name;

  NoticeBoard({required this.id, required this.name});

  factory NoticeBoard.fromJson(Map<String, dynamic> json) {
    return NoticeBoard(
      id: json['_id'],
      name: json['name'],
    );
  }

  NoticeBoard copyWith({
    String? id,
    String? name,
  }) {
    return NoticeBoard(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
