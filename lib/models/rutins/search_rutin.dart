class RutinQuarry {
  List<Routine> routine;
  int currentPage;
  int totalPages;

  RutinQuarry(
      {required this.routine,
      required this.currentPage,
      required this.totalPages});

  factory RutinQuarry.fromJson(Map<String, dynamic> json) {
    var list = json['routine'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return RutinQuarry(
      routine: routines,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

class Routine {
  String id;
  String name;
  Owner owner;

  Routine({required this.id, required this.name, required this.owner});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['_id'],
      name: json['name'],
      owner: Owner.fromJson(json['ownerid']),
    );
  }
}

class Owner {
  String id;
  String username;
  String name;

  Owner({required this.id, required this.username, required this.name});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      username: json['username'],
      name: json['name'],
    );
  }
}
