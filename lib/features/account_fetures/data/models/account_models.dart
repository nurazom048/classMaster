class AccountModels {
  String? id;
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
    this.username,
    this.name,
    this.password,
    this.image,
    this.position,
    this.about,
    this.accountType,
  });

  AccountModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    image = json['image'] == "null" ? null : json['image'];
    position = json['position'];
    about = json['about'];
    accountType = json['accountType'];
    coverImage = json['coverImage'] == "null" ? null : json['coverImage'];
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
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      image: image ?? this.image,
      position: position ?? this.position,
    );
  }
}
