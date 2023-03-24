class SummayModels {
  SummayModels({required this.summaries});

  List<Summary> summaries;

  factory SummayModels.fromJson(Map<String, dynamic> json) => SummayModels(
        summaries: List<Summary>.from(
            json["summaries"].map((x) => Summary.fromJson(x))),
      );

  SummayModels copyWith({List<Summary>? summaries}) {
    return SummayModels(summaries: summaries ?? this.summaries);
  }
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

  Summary copyWith({
    String? text,
    String? id,
    DateTime? time,
  }) {
    return Summary(
      text: text ?? this.text,
      id: id ?? this.id,
      time: time ?? this.time,
    );
  }
}
