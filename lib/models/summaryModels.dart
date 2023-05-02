class Summary {
  final String message;
  final List<SummaryItem> summaryItems;

  Summary({
    required this.message,
    required this.summaryItems,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    List<SummaryItem> summaryItems = [];
    for (final item in json['summarys']) {
      summaryItems.add(SummaryItem.fromJson(item));
    }
    return Summary(
      message: json['message'],
      summaryItems: summaryItems,
    );
  }
}

class SummaryItem {
  final String id;
  final String ownerId;
  final String text;
  final List<String> imageLinks;
  final String routineId;
  final String classId;
  final int v;

  SummaryItem({
    required this.id,
    required this.ownerId,
    required this.text,
    required this.imageLinks,
    required this.routineId,
    required this.classId,
    required this.v,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      id: json['_id'],
      ownerId: json['ownerId'],
      text: json['text'],
      imageLinks: List<String>.from(json['imageLinks']),
      routineId: json['routineId'],
      classId: json['classId'],
      v: json['__v'],
    );
  }
}












// class SummayModels {
//   SummayModels({required this.summaries});

//   List<Summary> summaries;

//   factory SummayModels.fromJson(Map<String, dynamic> json) => SummayModels(
//         summaries: List<Summary>.from(
//             json["summaries"].map((x) => Summary.fromJson(x))),
//       );

//   SummayModels copyWith({List<Summary>? summaries}) {
//     return SummayModels(summaries: summaries ?? this.summaries);
//   }
// }

// class Summary {
//   Summary({
//     required this.text,
//     required this.id,
//     required this.time,
//   });

//   String text;
//   String id;
//   DateTime time;

//   factory Summary.fromJson(Map<String, dynamic> json) => Summary(
//         text: json["text"],
//         id: json["_id"],
//         time: DateTime.parse(json["time"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "text": text,
//         "_id": id,
//         "time": time.toIso8601String(),
//       };

//   Summary copyWith({
//     String? text,
//     String? id,
//     DateTime? time,
//   }) {
//     return Summary(
//       text: text ?? this.text,
//       id: id ?? this.id,
//       time: time ?? this.time,
//     );
//   }
// }
