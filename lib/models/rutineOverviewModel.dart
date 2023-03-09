import 'dart:convert';

RutinOverviewModel rutinOverviewModelFromJson(String str) =>
    RutinOverviewModel.fromJson(json.decode(str));

class RutinOverviewModel {
  RutinOverviewModel({
    required this.message,
    required this.rutins,
  });

  String message;
  List<Rutin> rutins;

  factory RutinOverviewModel.fromJson(Map<String, dynamic> json) =>
      RutinOverviewModel(
        message: json["message"],
        rutins: List<Rutin>.from(json["rutins"].map((x) => Rutin.fromJson(x))),
      );
}

class Rutin {
  Rutin({
    required this.lastSummary,
    required this.id,
    required this.name,
    this.ownerid,
  });

  LastSummary lastSummary;
  String id;
  String name;
  Ownerid? ownerid;

  factory Rutin.fromJson(Map<String, dynamic> json) => Rutin(
        lastSummary: LastSummary.fromJson(json["last_summary"]),
        id: json["_id"],
        name: json["name"],
        ownerid:
            json["ownerid"] == null ? null : Ownerid.fromJson(json["ownerid"]),
      );
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
}

class Ownerid {
  Ownerid({
    required this.id,
    required this.username,
    required this.name,
    this.image,
  });

  String id;
  String username;
  String name;
  String? image;

  factory Ownerid.fromJson(Map<String, dynamic> json) => Ownerid(
        id: json["_id"],
        username: json["username"],
        name: json["name"],
        image: json["image"],
      );
}
