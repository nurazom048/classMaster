class SaveRoutineResponse {
  List<SaveRoutine> savedRoutines;
  int currentPage;
  int totalPages;

  SaveRoutineResponse({
    required this.savedRoutines,
    required this.currentPage,
    required this.totalPages,
  });

  factory SaveRoutineResponse.fromJson(Map<String, dynamic> json) {
    return SaveRoutineResponse(
      savedRoutines: List<SaveRoutine>.from(
        json['savedRoutines'].map((routine) => SaveRoutine.fromJson(routine)),
      ),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  SaveRoutineResponse copyWith({
    List<SaveRoutine>? savedRoutines,
    int? currentPage,
    int? totalPages,
  }) {
    return SaveRoutineResponse(
      savedRoutines: savedRoutines ?? this.savedRoutines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class SaveRoutine {
  bool isSaved;
  String memberID;
  RoutineID routineID;
  bool notificationOn;
  bool captain;
  bool owner;
  bool blocklist;

  SaveRoutine({
    required this.isSaved,
    required this.memberID,
    required this.routineID,
    required this.notificationOn,
    required this.captain,
    required this.owner,
    required this.blocklist,
  });

  factory SaveRoutine.fromJson(Map<String, dynamic> json) {
    return SaveRoutine(
      isSaved: json['isSaved'],
      memberID: json['memberID'],
      routineID: RoutineID.fromJson(json['RutineID']),
      notificationOn: json['notificationOn'],
      captain: json['captain'],
      owner: json['owner'],
      blocklist: json['blocklist'],
    );
  }
}

class RoutineID {
  String id;
  String name;

  RoutineID({
    required this.id,
    required this.name,
  });

  factory RoutineID.fromJson(Map<String, dynamic> json) {
    return RoutineID(
      id: json['_id'],
      name: json['name'],
    );
  }
}
