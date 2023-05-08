// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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

      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);
        final routines = json.decode(response.body)["user"]["routines"];

        //... save token
        final prefs = await SharedPreferences.getInstance();
        var savetoken = await prefs.setString('Token', accountData["token"]);

        return right(message);
      } else {
        return left(message.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //  create a new account
  static Future<Either<String, Message>> createAccount(context,
      {required name, required username, required password}) async {
    try {
      //... send request
      final response =
          await http.post(Uri.parse('${Const.BASE_URl}/auth/create'), body: {
        "name": name,
        "username": username,
        "password": password,
      });

      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
        return right(Message.fromJson(json.decode(response.body)));
      } else {
        return left(json.decode(response.body));
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}

final authReqProvider = Provider((ref) => AuthReq());
