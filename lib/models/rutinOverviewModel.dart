class RutinOverviewMode {
  RutinOverviewMode({
    required this.lastSummary,
    required this.id,
    required this.name,
    required this.ownerid,
  });

  LastSummary lastSummary;
  String id;
  String name;
  Ownerid ownerid;

  factory RutinOverviewMode.fromJson(Map<String, dynamic> json) =>
      RutinOverviewMode(
        lastSummary: LastSummary.fromJson(json["last_summary"]),
        id: json["_id"],
        name: json["name"],
        ownerid: Ownerid.fromJson(json["ownerid"]),
      );

  Map<String, dynamic> toJson() => {
        "last_summary": lastSummary.toJson(),
        "_id": id,
        "name": name,
        "ownerid": ownerid.toJson(),
      };
}

class LastSummary {
  LastSummary({
    required this.text,
    required this.time,
  });

  String text;
  DateTime time;

  factory LastSummary.fromJson(Map<String, dynamic> json) => LastSummary(
        text: json["text"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "time": time.toIso8601String(),
      };
}

class Ownerid {
  Ownerid({
    required this.id,
    required this.username,
    required this.name,
    required this.image,
  });

  String id;
  String username;
  String name;
  String image;

  factory Ownerid.fromJson(Map<String, dynamic> json) => Ownerid(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "name": name,
        "image": image,
      };
}
