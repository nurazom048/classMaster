import 'dart:convert';

SummayModels summayModelsFromJson(String str) =>
    SummayModels.fromJson(json.decode(str));

String summayModelsToJson(SummayModels data) => json.encode(data.toJson());

class SummayModels {
  SummayModels({required this.summaries});

  List<Summary> summaries;

  factory SummayModels.fromJson(Map<String, dynamic> json) => SummayModels(
        summaries: List<Summary>.from(
            json["summaries"].map((x) => Summary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summaries": List<dynamic>.from(summaries.map((x) => x.toJson())),
      };
}

class Summary {
  Summary({
    required this.text,
    required this.id,
    required this.time,
  });

  String text;
  String id;
  DateTime time;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        text: json["text"],
        id: json["_id"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "_id": id,
        "time": time.toIso8601String(),
      };
}
