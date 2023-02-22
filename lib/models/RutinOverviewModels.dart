class RutinOverviewModels {
  String? sId;
  String? name;
  Ownerid? ownerid;

  List<Priode>? priode;

  RutinOverviewModels({this.sId, this.name, this.ownerid, this.priode});

  RutinOverviewModels.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    ownerid =
        json['ownerid'] != null ? Ownerid.fromJson(json['ownerid']) : null;

    if (json['priode'] != null) {
      priode = <Priode>[];
      json['priode'].forEach((v) {
        priode!.add(Priode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    if (ownerid != null) {
      data['ownerid'] = ownerid!.toJson();
    }

    if (priode != null) {
      data['priode'] = priode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ownerid {
  String? sId;
  String? username;
  String? name;
  String? image;

  Ownerid({this.sId, this.username, this.name, this.image});

  Ownerid.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['username'] = username;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Priode {
  String? startTime;
  String? endTime;
  String? sId;

  Priode({this.startTime, this.endTime, this.sId});

  Priode.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['_id'] = sId;
    return data;
  }
}
