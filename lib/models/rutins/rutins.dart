class Routine {
  LastSummary lastSummary;
  String id;
  String name;
  Owner owner;

  Routine(
      {required this.lastSummary,
      required this.id,
      required this.name,
      required this.owner});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
        lastSummary: LastSummary.fromJson(json['last_summary']),
        id: json['_id'],
        name: json['name'],
        owner: Owner.fromJson(json['ownerid']));
  }

  Routine copyWith({
    LastSummary? lastSummary,
    String? id,
    String? name,
    Owner? owner,
  }) {
    return Routine(
      lastSummary: lastSummary ?? this.lastSummary,
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
    );
  }
}

class LastSummary {
  String text;
  String time;

  LastSummary({required this.text, required this.time});

  factory LastSummary.fromJson(Map<String, dynamic> json) {
    return LastSummary(text: json['text'], time: json['time']);
  }
}

class Owner {
  String id;
  String username;
  String name;
  String image;

  Owner(
      {required this.id,
      required this.username,
      required this.name,
      required this.image});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
        id: json['_id'],
        username: json['username'],
        name: json['name'],
        image: json['image']);
  }
}