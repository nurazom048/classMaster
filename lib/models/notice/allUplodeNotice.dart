class AllUploadedNotice {
  String message;
  List<Notice> notice;

  AllUploadedNotice({required this.message, required this.notice});

  factory AllUploadedNotice.fromJson(Map<String, dynamic> json) {
    var noticeList = json['notice'] as List;
    List<Notice> notices =
        noticeList.map((notice) => Notice.fromJson(notice)).toList();

    return AllUploadedNotice(
      message: json['message'],
      notice: notices,
    );
  }
}

class Notice {
  String id;
  String owner;
  String name;

  Notice({required this.id, required this.owner, required this.name});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['_id'],
      owner: json['owner'],
      name: json['name'],
    );
  }
}
