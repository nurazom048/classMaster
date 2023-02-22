// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class AccountModels {
  String? sId;
  String? username;
  String? name;
  String? password;
  String? image;

  AccountModels(
      {this.sId, this.username, this.name, this.password, this.image});

  AccountModels.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    image = json['image'];
  }

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
