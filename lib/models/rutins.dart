class Routine {
  final LastSummary lastSummary;
  final String id;
  final String name;
  final Owner owner;

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
      owner: Owner.fromJson(json['ownerid']),
    );
  }
}

class RoutinesResponse {
  final String message;
  final List<Routine> routines;

  RoutinesResponse({required this.message, required this.routines});

  factory RoutinesResponse.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = [];
    for (var routineJson in json['routines']) {
      routines.add(Routine.fromJson(routineJson));
    }
    return RoutinesResponse(
      message: json['message'],
      routines: routines,
    );
  }
}

class LastSummary {
  final String text;
  final String time;

  LastSummary({required this.text, required this.time});

  factory LastSummary.fromJson(Map<String, dynamic> json) {
    return LastSummary(
      text: json['text'],
      time: json['time'],
    );
  }
}

class Owner {
  final String id;
  final String username;
  final String name;
  final String image;

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
      image: json['image'],
    );
  }
}
