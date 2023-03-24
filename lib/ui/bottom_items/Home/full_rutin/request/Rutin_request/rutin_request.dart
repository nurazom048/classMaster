// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/chackStatusModel.dart';
import '../../../../../../../models/messageModel.dart';

//*** Providers  ******   */
final FullRutinProvider = Provider((ref) => FullRutinrequest());

//..delete rutin ...//
final deleteRutinProvider =
    FutureProvider.family.autoDispose<Message?, String>((ref, rutin_id) {
  return ref.watch(FullRutinProvider).deleteRutin(rutin_id);
});

// final chackStatusUser_provider = FutureProvider.family
//     .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
//   return ref.read(FullRutinProvider).chackStatus(rutin_id);
// });

class FullRutinrequest {
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
  Future<Message> deleteClass(context, classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse('${Const.BASE_URl}/class/delete/$classId');

    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      Message message = Message.fromJson(json.decode(response.body));

      //
      if (response.statusCode == 200) {
        return message;
      } else {
        throw Exception(message.message);
      }
    } catch (e) {
      throw Exception(e);
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

//... Save unsve rutin.....///

  Future<Either<String, Message>> saveUnsaveRutinReq(rutinId, condition) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/save_unsave/$rutinId');
    final headers = {'Authorization': 'Bearer $getToken'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {'saveCondition': '$condition'},
      );

      final res = json.decode(response.body);
      final message = Message.fromJson(res);
      print('from unsave: $res');

      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      print(e.toString());
      return left(e.toString());
    }
  }
}
