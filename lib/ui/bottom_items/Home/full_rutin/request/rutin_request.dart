// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/models/seeAllRequestModel.dart';
import 'package:table/widgets/Alart.dart';

final RutinProvider = Provider((ref) => FullRutinrequest());

class FullRutinrequest {
  //
  //...acceptRequest.....//
  Future acceptRequest(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("$username");

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/acsept_request/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'},
          body: {"username": username});

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (response.body != null) {
          var res = jsonDecode(response.body);
          print(res);
          return res;
        } else {
          print(res);
          throw Exception("Response body is null");
        }
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //

  //
  //...acceptRequest.....//
  Future rejectRequest(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("$username");

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/reject_request/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'},
          body: {"username": username});

      var res = jsonDecode(response.body);
      print("rej");
      print(res);

      if (response.statusCode == 200) {
        if (response.body != null) {
          var res = jsonDecode(response.body);

          return res;
        } else {
          throw Exception("Response body is null");
        }
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //....ChackStatusModel....//
  Future<CheckStatusModel> chackStatus(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/rutin/status/$rutin_id'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      if (response.statusCode == 200) {
        if (response.body != null) {
          CheckStatusModel res =
              CheckStatusModel.fromJson(jsonDecode(response.body));
          print(res);
          return res;
        } else {
          throw Exception("Response body is null");
        }
      } else {
        throw Exception("Failed to load status");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //....sell all request ....//
  Future<RequestModel> sell_all_request(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/rutin/member/see_all_request/$rutin_id'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      if (response.statusCode == 200) {
        if (response.body != null) {
          RequestModel res = RequestModel.fromJson(jsonDecode(response.body));
          print(res);
          return res;
        } else {
          throw Exception("Response body is null");
        }
      } else {
        throw Exception("Failed to load status");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //,, delete class
  Future<Either<String, Message>> deleteClass(context, classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/class/delete/$classId');

    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});

      var res = json.decode(response.body);
      print("res $res");

      var message = Message.fromJson(res);

      if (response.statusCode == 200) {
        return right(message);
      } else {
        throw Exception(message.message);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
