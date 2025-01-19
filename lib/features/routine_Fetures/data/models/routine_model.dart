class Routine {
  Routine({
    required this.id,
    required this.name,
    required this.owner,
  });

  String id;
  String name;
  Owner owner;

  factory Routine.fromJson(
    String id,
    String name,
    Owner owner,
  ) =>
      Routine(
        id: id,
        name: name,
        owner: owner,
      );

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
  Owner({
    required this.id,
    required this.username,
    this.name,
    this.image,
  });

  String id;
  String username;
  String? name;
  String? image;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
      id: json["_id"],
      username: json["username"],
      name: json['name'],
      image: json['image']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };

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
