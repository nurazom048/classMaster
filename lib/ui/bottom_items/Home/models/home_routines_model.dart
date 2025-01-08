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

  Map<String, dynamic> toJson() => {
        "message": message,
        "homeRoutines": homeRoutines.map((x) => x.toJson()).toList(),
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
      };
}

class HomeRoutine {
  String memberId;
  RutineId rutineId;
  bool notificationOn;
  bool captain;
  bool owner;
  bool blocklist;

  HomeRoutine({
    required this.memberId,
    required this.rutineId,
    required this.notificationOn,
    required this.captain,
    required this.owner,
    required this.blocklist,
  });

  factory HomeRoutine.fromJson(Map<String, dynamic> json) {
    return HomeRoutine(
      memberId: json["memberID"],
      rutineId: RutineId.fromJson(json["RutineID"]),
      notificationOn: json["notificationOn"],
      captain: json["captain"],
      owner: json["owner"],
      blocklist: json["blocklist"],
    );
  }

  HomeRoutine copyWith({
    String? memberId,
    RutineId? rutineId,
    bool? notificationOn,
    bool? captain,
    bool? owner,
    bool? blocklist,
  }) {
    return HomeRoutine(
      memberId: memberId ?? this.memberId,
      rutineId: rutineId ?? this.rutineId,
      notificationOn: notificationOn ?? this.notificationOn,
      captain: captain ?? this.captain,
      owner: owner ?? this.owner,
      blocklist: blocklist ?? this.blocklist,
    );
  }

  Map<String, dynamic> toJson() => {
        "memberID": memberId,
        "RutineID": rutineId.toJson(),
        "notificationOn": notificationOn,
        "captain": captain,
        "owner": owner,
        "blocklist": blocklist,
      };
}

class RutineId {
  String id;
  String routineName;

  RutineId({
    required this.id,
    required this.routineName,
  });

  factory RutineId.fromJson(Map<String, dynamic> json) {
    return RutineId(
      id: json["id"],
      routineName: json["routineName"], // Use routineName from JSON
    );
  }

  RutineId copyWith({
    String? id,
    String? routineName,
  }) {
    return RutineId(
      id: id ?? this.id,
      routineName: routineName ?? this.routineName,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "routineName": routineName, // Use routineName for serialization
      };
}
