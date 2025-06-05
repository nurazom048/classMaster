import '../../../account_fetures/data/models/account_models.dart';

class RoutineQuery {
  List<Routine> routines;
  int currentPage;
  int totalPages;
  int totalCount;

  RoutineQuery({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory RoutineQuery.fromJson(Map<String, dynamic> json) {
    var list = json['routines'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return RoutineQuery(
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

  RoutineQuery copyWith({
    List<Routine>? routines,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return RoutineQuery(
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
  AccountModels owner;

  Routine({required this.id, required this.name, required this.owner});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['routineName'],
      owner: AccountModels.fromJson(json['routineOwner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'routineName': name};
  }

  Routine copyWith({String? id, String? name, AccountModels? owner}) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
    );
  }
}
