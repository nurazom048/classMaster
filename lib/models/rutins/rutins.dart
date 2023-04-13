// class Routine {
//   String id;
//   String name;
//   Owner owner;

//   Routine({required this.id, required this.name, required this.owner});

//   factory Routine.fromJson(Map<String, dynamic> json) {
//     return Routine(
//         id: json['_id'],
//         name: json['name'] ?? '',
//         owner: Owner.fromJson(json['ownerid']));
//   }

//   Routine copyWith({
//     LastSummary? lastSummary,
//     String? id,
//     String? name,
//     Owner? owner,
//   }) {
//     return Routine(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       owner: owner ?? this.owner,
//     );
//   }
// }

// class LastSummary {
//   String text;
//   String time;

//   LastSummary({required this.text, required this.time});

//   factory LastSummary.fromJson(Map<String, dynamic> json) {
//     return LastSummary(text: json['text'], time: json['time']);
//   }
// }

// class Owner {
//   String id;
//   String username;
//   String name;
//   String image;

//   Owner(
//       {required this.id,
//       required this.username,
//       required this.name,
//       required this.image});

//   factory Owner.fromJson(Map<String, dynamic> json) {
//     return Owner(
//         id: json['_id'],
//         username: json['username'],
// name: json['name'],
// image: json['image']);
//   }
// }

class Routine {
  Routine({
    required this.id,
    required this.name,
    required this.owner,
    required this.lastSummary,
  });

  String id;
  String name;
  Owner owner;
  LastSummary lastSummary;

  factory Routine.fromJson(
          String id, String name, Owner owner, LastSummary lastSummary) =>
      Routine(
        id: id,
        name: name,
        owner: owner,
        lastSummary: lastSummary,
      );
}

class Owner {
  Owner({
    required this.id,
    required this.username,
    this.name,
    this.image,
  });

  String id;
  String username;
  String? name;
  String? image;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
      id: json["_id"],
      username: json["username"],
      name: json['name'],
      image: json['image']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
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
}
