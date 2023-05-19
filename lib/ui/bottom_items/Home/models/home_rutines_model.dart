class RoutineHome {
  String memberID;
  RutineID rutineID;
  bool notificationOn;
  bool captain;
  bool owner;
  bool blocklist;

  RoutineHome({
    required this.memberID,
    required this.rutineID,
    required this.notificationOn,
    required this.captain,
    required this.owner,
    required this.blocklist,
  });

  factory RoutineHome.fromJson(Map<String, dynamic> json) {
    return RoutineHome(
      memberID: json['memberID'],
      rutineID: RutineID.fromJson(json['RutineID']),
      notificationOn: json['notificationOn'],
      captain: json['captain'],
      owner: json['owner'],
      blocklist: json['blocklist'],
    );
  }
}

class RutineID {
  String id;
  String name;

  RutineID({
    required this.id,
    required this.name,
  });

  factory RutineID.fromJson(Map<String, dynamic> json) {
    return RutineID(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class HomeRoutines {
  String message;
  List<RoutineHome> homeRoutines;
  int currentPage;
  int totalPages;
  int totalItems;

  HomeRoutines({
    required this.message,
    required this.homeRoutines,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory HomeRoutines.fromJson(Map<String, dynamic> json) {
    return HomeRoutines(
      message: json['message'],
      homeRoutines: List<RoutineHome>.from(
          json['homeRutines'].map((x) => RoutineHome.fromJson(x))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
    );
  }
}
