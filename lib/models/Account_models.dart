class AccountModels {
  String? sId;
  String? username;
  String? name;
  String? password;
  String? image;
  String? position;

  AccountModels(data,
      {this.sId,
      this.username,
      this.name,
      this.password,
      this.image,
      this.position});

  AccountModels.fromJson(json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    image = json['image'];
    position = json['position'];

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data['_id'] = sId;
      data['username'] = username;
      data['name'] = name;
      data['password'] = password;
      data['image'] = image;
      return data;
    }
  }
}
