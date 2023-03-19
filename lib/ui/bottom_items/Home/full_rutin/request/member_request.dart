// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/Rutin_request/rutin_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/add_members.dart';

class memberRequest {
//
//**********************   rutin all _members    *********** */
  Future<MembersModel?> all_members(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (response.body != null) {
          print(res);
          return MembersModel.fromJson(res);
        } else {
          throw Exception("faild to load all member list ");
        }
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

//**********************   addMember   *********** */
  Future<String?> addMemberReq(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/add/$rutin_id/$username'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body)["message"];

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("faild to load all member list ");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

//**********************   remove members   *********** */
  Future<String?> removeMemberReq(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url =
        Uri.parse('${Const.BASE_URl}/rutin/member/remove/$rutin_id/$username');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body)["message"];

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("faild to load all member list ");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //.... add cap10s.../
  Future<String> addCaptens({rutinid, position, username}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final url = Uri.parse('${Const.BASE_URl}/rutin/cap10/add');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $getToken'
    }, body: {
      "rutinid": rutinid,
      "position": position ?? "ist cap 10 ",
      "username": username
    });

    try {
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body)['Message'];
        print(res);
        return res;
      } else {
        return " fails to add cap10";
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final memberRequestProvider = Provider((ref) => memberRequest());
