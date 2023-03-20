// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/svae_unsave.dart';
import 'package:table/widgets/Alart.dart';

final chackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider).chackStatus(rutin_id);
});
// final saveRutin_provider =
//     FutureProvider.family.autoDispose<dynamic, String>((ref, rutin_id) {
//   return ref.read(FullRutinProvider).saveRutin(rutin_id);
// });

// final unSave_Rutin_provider =
//     FutureProvider.family.autoDispose<dynamic, String>((ref, rutin_id) {
//   return ref.read(FullRutinProvider).unSaveRutin(rutin_id);
// });

class FullRutinrequest extends saveUnsave {
  //
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
}

final FullRutinProvider = Provider((ref) => FullRutinrequest());

class ClassesRequest {
  //
  //,, delete class
  Future<void> deleteClass(context, classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.delete(
          Uri.parse('${Const.BASE_URl}/class/delete/$classId'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        var message = json.decode(response.body)["message"];
        Alart.handleError(context, message.toString());
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e);
    }
  }
}
