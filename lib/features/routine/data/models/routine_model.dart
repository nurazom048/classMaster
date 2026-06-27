import '../../../account_fetures/data/models/account_models.dart';

class Routine {
  String id;
  String routineName;
  String ownerAccountId;

  RoutineOwner routineOwner;

  Routine({
    required this.id,
    required this.routineName,
    required this.ownerAccountId,

    required this.routineOwner,
  });

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json["id"],
    routineName: json["routineName"],
    ownerAccountId: json["ownerAccountId"],
    routineOwner: RoutineOwner.fromJson(json["routineOwner"]),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "routineName": routineName,
    "ownerAccountId": ownerAccountId,
  };
}

class RoutineOwner {
  final String? id;
  String name;
  String username;
  String image;

  RoutineOwner({
    this.id,
    required this.name,
    required this.username,
    required this.image,
  });

  factory RoutineOwner.fromJson(Map<String, dynamic> json) => RoutineOwner(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    image: json["image"],
  );
}

//
