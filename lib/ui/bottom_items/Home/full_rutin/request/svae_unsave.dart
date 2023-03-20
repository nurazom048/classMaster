// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

class p {
  final String r;
  final bool c;
  p({required this.r, required this.c});
}

final saveProvider = FutureProvider.family<bool, p>((ref, p) async {
  return await ref.read(saveUnsaveProvider).saveRutin(p.r, p.c);
});

// final unsaveProvider =
//     FutureProvider.family<bool, String>((ref, rutinId) async {
//   return ref.read(saveUnsaveProvider).unSaveRutin(rutinId);
// });

class saveUnsave {
//... unsave rutine ....//
  Future<bool> saveRutin(String rutinId, bool consition) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("r : $rutinId b : $consition");

    var url = Uri.parse('${Const.BASE_URl}/rutin/save_unsave/$rutinId');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"saveCondition": true},
      );

      final res = json.decode(response.body);
      print(" vai res ${res}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<bool> unSaveRutin(rutinId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');
  //   try {
  //     final response = await http.get(
  //         Uri.parse('${Const.BASE_URl}/rutin/unsave/$rutinId'),
  //         headers: {'Authorization': 'Bearer $getToken'});

  //     final res = json.decode(response.body);

  //     if (response.statusCode == 200) {
  //       print("from unsave :$res");

  //       return res["save"];
  //     } else {
  //       return res["save"];
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}

final saveUnsaveProvider = Provider<saveUnsave>((ref) => saveUnsave());
