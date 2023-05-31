// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';

import '../../../constant/constant.dart';

class AuthReq {
  //........ Login .........//
  Future<Either<String, String>> login({username, password}) async {
    var loginUrl = Uri.parse('${Const.BASE_URl}/auth/login');
    try {
      final response = await http
          .post(loginUrl, body: {"username": username, "password": password});

      var message = json.decode(response.body)["message"];
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);

        //... save token
        final prefs = await SharedPreferences.getInstance();
        var savetoken = await prefs.setString('Token', accountData["token"]);

        return right(message);
      } else {
        return left(message.toString());
      }
    } catch (e) {
      print(e);
      return left(e.toString());
    }
  }

  //  create a new account
  static Future<Either<Message, Message>> createAccount(context,
      {required name,
      required username,
      required password,
      required email}) async {
    try {
      //... send request
      final response = await http
          .post(Uri.parse('${Const.BASE_URl}/auth/create'), body: {
        "name": name,
        "username": username,
        "password": password,
        "email": email
      });

      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
        return right(Message.fromJson(res));
      } else {
        return right(Message.fromJson(res));
      }
    } catch (e) {
      print(e.toString());
      return left(Message(message: e.toString()));
    }
  }

  //***************  Account data  *************//
  Future<Either<String, Message>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse('${Const.BASE_URl}/account/eddit/changepassword');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
      print(jsonDecode(response.body));

      Message message = Message.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //

  Future<Either<String, Message>> forgrtPassword(String newPassword,
      {String? email, String? phone}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse('${Const.BASE_URl}/account/eddit/forgotPassword');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
          "email": email.toString(),
          "phone": phone.toString(),
          "newPassword": newPassword
        },
      );

      Message message = Message.fromJson(json.decode(response.body));

      print("....................................");
      print(jsonDecode(response.body));

      print(json.decode(response.body));
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}

final authReqProvider = Provider((ref) => AuthReq());
