class Notice {
  String? id;
  String? contentName;
  List<Pdf>? pdfList;
  String? description;
  NoticeBoard? noticeBoard;
  String? visibility;
  String? time;

  Notice({
    this.id,
    this.contentName,
    this.pdfList,
    this.description,
    this.noticeBoard,
    this.visibility,
    this.time,
  });

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    contentName = json['content_name'];
    if (json['pdf'] != null) {
      pdfList = [];
      json['pdf'].forEach((v) {
        pdfList?.add(Pdf.fromJson(v));
      });
    }
    description = json['description'];
    noticeBoard = json['noticeBoard'] != null
        ? NoticeBoard.fromJson(json['noticeBoard'])
        : null;
    visibility = json['visibility'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['content_name'] = contentName;
    if (pdfList != null) {
      data['pdf'] = pdfList?.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    if (noticeBoard != null) {
      data['noticeBoard'] = noticeBoard?.toJson();
    }
    data['visibility'] = visibility;
    data['time'] = time;
    return data;
  }
}

class Pdf {
  String? url;
  String? id;

  Pdf({
    this.url,
    this.id,
  });

  Pdf.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    data['_id'] = id;
    return data;
  }
}

class NoticeBoard {
  String? id;
  Account? owner;
  String? name;

  NoticeBoard({
    this.id,
    this.owner,
    this.name,
  });

  NoticeBoard.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    owner = json['owner'] != null ? Account.fromJson(json['owner']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    if (owner != null) {
      data['owner'] = owner?.toJson();
    }
    data['name'] = name;
    return data;
  }
}

class Account {
  String? id;
  String? username;
  String? name;

  Account({
    this.id,
    this.username,
    this.name,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['username'] = username;
    data['name'] = name;
    return data;
  }
}
