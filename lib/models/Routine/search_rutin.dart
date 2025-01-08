class RutinQuarry {
  List<Routine> routines;
  int currentPage;
  int totalPages;
  int totalCount;

  RutinQuarry({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory RutinQuarry.fromJson(Map<String, dynamic> json) {
    var list = json['routines'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return RutinQuarry(
      routines: routines,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routines': routines.map((routine) => routine.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
    };
  }

  RutinQuarry copyWith({
    List<Routine>? routines,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return RutinQuarry(
      routines: routines ?? this.routines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class Routine {
  String id;
  String name;
  Owner owner;

  Routine({
    required this.id,
    required this.name,
    required this.owner,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['routineName'],
      owner: Owner.fromJson(json['routineOwner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineName': name,
      'routineOwner': owner.toJson(),
    };
  }

  Routine copyWith({
    String? id,
    String? name,
    Owner? owner,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
    );
  }
}

class Owner {
  String id;
  String username;
  String name;
  String? image;

  Owner({
    required this.id,
    required this.username,
    required this.name,
    this.image,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'image': image,
    };
  }

  Owner copyWith({
    String? id,
    String? username,
    String? name,
    String? image,
  }) {
    return Owner(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
