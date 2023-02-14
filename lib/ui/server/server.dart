// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/ui/bottom_items/bottm_nev_bar.dart';

class RutinServer {
//........ Login .........//

  String base = "192.168.0.125:3000";
  //String base = "localhost:3000";
  String? message;
  Future<void> login(context, {username, password}) async {
    try {
      //... send request
      final response = await http.post(Uri.parse('http://$base/auth/login'),
          body: {"username": username, "password": password});

      message = json.decode(response.body)["message"];

      if (response.statusCode == 200) {
        //.. responce
        final accountData = json.decode(response.body);
        final routines = json.decode(response.body)["user"]["routines"];

        //... save token
        final prefs = await SharedPreferences.getInstance();
        var savetoken = await prefs.setString('Token', accountData["token"]);

        // print(routines[1]["name"]);
        print("login");
        print(savetoken);

        // Navigate to the "routine_screen"
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNevBar()));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }
}
