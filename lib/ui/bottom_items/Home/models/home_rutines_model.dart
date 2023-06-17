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
  String name;

  RutineId({
    required this.id,
    required this.name,
  });

  factory RutineId.fromJson(Map<String, dynamic> json) {
    return RutineId(
      id: json["_id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
