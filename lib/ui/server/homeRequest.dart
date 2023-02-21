import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/Alart.dart';

class HomeReq {
  String base = "http://192.168.0.125:3000";
  // String base = "http://192.168.31.229:3000";
  String? message;
//... myall rutin ,,,//
  Future<List> myAllRutin() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
//.. request
    final response = await http.post(Uri.parse('$base/rutin/allrutins'),
        headers: {'Authorization': 'Bearer $getToken'});

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body)["user"];
      Map<String, dynamic> data = res as Map<String, dynamic>;
      return data["routines"] ?? [];

      //
    } else {
      throw Exception('Failed to load data');
    }
  }

//... myall rutin ,,,//
  Future<List> savedRutins(context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
//.. request
    final response = await http.post(Uri.parse('$base/rutin/allrutins'),
        headers: {'Authorization': 'Bearer $getToken'});
    message = json.decode(response.body)["message"];

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body)["user"];

      Map<String, dynamic> savedRutins = res as Map<String, dynamic>;
      return savedRutins["Saved_routines"] ?? [];

      //
    } else {
      Alart().errorAlartDilog(context, message!);

      return [];
    }
  }
}
