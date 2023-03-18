// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

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
}

final auth_req_provider = Provider((ref) => AuthReq());
