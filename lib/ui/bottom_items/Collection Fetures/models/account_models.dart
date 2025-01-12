class AccountModels {
  String? id;
  String? sId;
  String? username;
  String? name;
  String? password;
  String? image;
  String? position;
  String? about;
  String? accountType;
  String? coverImage;

  AccountModels({
    this.id,
    this.sId,
    this.username,
    this.name,
    this.password,
    this.image,
    this.position,
    this.about,
    this.accountType,
  });

  AccountModels.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    image = json['image'];
    position = json['position'];
    about = json['about'];
    accountType = json['account_type'];
    coverImage = json['coverImage'];
  }

  AccountModels copyWith({
    String? id,
    String? sId,
    String? username,
    String? name,
    String? password,
    String? image,
    String? position,
  }) {
    return AccountModels(
      id: sId ?? this.id,
      sId: sId ?? this.sId,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      image: image ?? this.image,
      position: position ?? this.position,
    );
  }
}
