// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

class AuthReq {
  //
  //
  //........ Login .........//
  Future<Either<String, dynamic>> login({username, password}) async {
    var loginUrl = Uri.parse('${Const.BASE_URl}/auth/login');
    try {
      final response = await http
          .post(loginUrl, body: {"username": username, "password": password});

      var message = json.decode(response.body)["message"];

      if (response.statusCode == 200) {
        //.. responce
        final accountData = json.decode(response.body);
        final routines = json.decode(response.body)["user"]["routines"];

        //... save token
        final prefs = await SharedPreferences.getInstance();
        var savetoken = await prefs.setString('Token', accountData["token"]);

        return right(true);
      } else {
        return left(message.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
