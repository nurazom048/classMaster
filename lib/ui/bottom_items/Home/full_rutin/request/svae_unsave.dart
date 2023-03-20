// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

final saveProvider =
    FutureProvider.family<Future, String>((ref, rutinId) async {
  return ref.read(saveUnsaveProvider).saveRutin(rutinId);
});

final unsaveProvider =
    FutureProvider.family<bool, String>((ref, rutinId) async {
  return ref.read(saveUnsaveProvider).unSaveRutin(rutinId);
});

class saveUnsave {
//... unsave rutine ....//
  Future saveRutin(rutinId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse('${Const.BASE_URl}/rutin/save/$rutinId'),
          headers: {'Authorization': 'Bearer $getToken'});

      final res = json.decode(response.body);
      print("$res");

      if (response.statusCode == 200) {
        print("from save :$res");

        return res["save"];
      } else {
        return res["save"];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> unSaveRutin(rutinId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse('${Const.BASE_URl}/rutin/unsave/$rutinId'),
          headers: {'Authorization': 'Bearer $getToken'});

      final res = json.decode(response.body);

      if (response.statusCode == 200) {
        print("from unsave :$res");

        return res["save"];
      } else {
        return res["save"];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final saveUnsaveProvider = Provider<saveUnsave>((ref) => saveUnsave());
