class AccountModels {
  String? sId;
  String? username;
  String? name;
  String? password;
  String? image;
  String? position;

  AccountModels(
      {this.sId,
      this.username,
      this.name,
      this.password,
      this.image,
      this.position});

  AccountModels.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    image = json['image'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['username'] = username;
    data['name'] = name;
    data['password'] = password;
    data['image'] = image;
    data['position'] = position;
    return data;
  }

  AccountModels copyWith({
    String? sId,
    String? username,
    String? name,
    String? password,
    String? image,
    String? position,
  }) {
    return AccountModels(
      sId: sId ?? this.sId,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      image: image ?? this.image,
      position: position ?? this.position,
    );
  }
}
