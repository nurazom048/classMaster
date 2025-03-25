import '../../../account_fetures/data/models/account_models.dart';

class RoutineHome {
  String message;
  List<HomeRoutine> homeRoutines;
  int currentPage;
  int totalPages;
  int totalItems;

  RoutineHome({
    required this.message,
    required this.homeRoutines,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory RoutineHome.fromJson(Map<String, dynamic> json) {
    return RoutineHome(
      message: json["message"],
      homeRoutines: (json["homeRoutines"] as List<dynamic>?)
              ?.map((x) => HomeRoutine.fromJson(x))
              .toList() ??
          [],
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] as int,
      totalItems: json["totalItems"] as int,
    );
  }

  RoutineHome copyWith({
    String? message,
    List<HomeRoutine>? homeRoutines,
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) {
    return RoutineHome(
      message: message ?? this.message,
      homeRoutines: homeRoutines ?? this.homeRoutines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class HomeRoutine {
  String id;
  String routineName;
  AccountModels routineOwner;

  HomeRoutine({
    required this.id,
    required this.routineName,
    required this.routineOwner,
  });

  factory HomeRoutine.fromJson(Map<String, dynamic> json) {
    return HomeRoutine(
      id: json["id"],
      routineName: json["routineName"],
      routineOwner: AccountModels.fromJson(json["routineOwner"]),
    );
  }

  HomeRoutine copyWith({
    String? id,
    String? routineName,
    AccountModels? routineOwner,
  }) {
    return HomeRoutine(
      id: id ?? this.id,
      routineName: routineName ?? this.routineName,
      routineOwner: routineOwner ?? this.routineOwner,
    );
  }
}
