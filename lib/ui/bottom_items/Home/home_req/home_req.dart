// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/listOfSaveRutin.dart';

//!.. Provider ...!//

final home_req_provider = Provider<HomeReq>((ref) => HomeReq());

final all_rutins_provider = FutureProvider<List>((ref) {
  return ref.read(home_req_provider).myAllRutin();
});
final save_rutins_provider = FutureProvider<ListOfSaveRutins>((ref) {
  return ref.read(home_req_provider).savedRutins();
});

//

class HomeReq {
  String? message;
//... myall rutin ,,,//
  Future<List> myAllRutin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/allrutins'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        //.. responce
        final res = json.decode(response.body)["user"];
        Map<String, dynamic> data = res as Map<String, dynamic>;
        return data["routines"] ?? [];

        //
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//********    savedRutins      *************/
  Future<ListOfSaveRutins> savedRutins({username}) async {
    String? username = "";
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/save_rutins/' + username);
    final headers = {'Authorization': 'Bearer $getToken'};

    //.. Request send
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);

        return ListOfSaveRutins.fromJson(res);
      } else {
        throw Exception("Failed to load saved routines");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
