// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/widgets/Alart.dart';
import '../../../../../../models/messageModel.dart';

//*** Providers  ******   */
final FullRutinProvider = StateNotifierProvider((ref) => FullRutinrequest());

//..delete rutin ...//
final deleteRutinProvider =
    FutureProvider.family.autoDispose<Message?, String>((ref, rutin_id) {
  return ref.watch(FullRutinProvider.notifier).deleteRutin(rutin_id);
});

final chackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider.notifier).chackStatus(rutin_id);
});

class FullRutinrequest extends StateNotifier<bool?> {
  FullRutinrequest() : super(null);

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

  //...... Delete Rutin.....//

  Future<Message?> deleteRutin(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/rutin/$rutin_id");

    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});

      var res = Message.fromJson(jsonDecode(response.body));
      print("req from delete req ${res.message}");

      if (response.statusCode == 200) {
        return res;
      } else {
        throw Exception(res.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
