// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/local%20data/api_cashe_maager.dart';
import 'package:table/models/check_status_model.dart';
import 'package:table/ui/bottom_items/Home/utils/utils.dart';
import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';

//*** Providers  ******   */
final fullRoutineProvider = Provider((ref) => FullRoutineRequest());

class FullRoutineRequest {
  //
  //....Check StatusModel....//
  Future<CheckStatusModel> chalkStatus(routineId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final bool isOnline = await Utils.isOnlineMethod();
    final key = "chalkStatus$routineId";
    final bool isHaveCash = await MyApiCash.haveCash(key);

    try {
      // if offline and have cash
      if (!isOnline && isHaveCash) {
        Map<String, dynamic> getData = await MyApiCash.getData(key);
        print('from cash $getData');
        return CheckStatusModel.fromJson(getData);
      } else if (!isOnline) {
        throw "You Are in Offline";
      } else {
        final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/status/$routineId'),
          headers: {'Authorization': 'Bearer $getToken'},
        );

        if (response.statusCode == 200) {
          // save to csh

          MyApiCash.saveLocal(key: key, syncData: response.body);

          CheckStatusModel res =
              CheckStatusModel.fromJson(jsonDecode(response.body));
          print("res  ${jsonDecode(response.body)}");
          return res;
        } else {
          throw Exception("Response body is null");
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());

      print(e);

      if (isHaveCash) {
        var getData =
            await APICacheManager().getCacheData("checkStatus$routineId");
        print('from cash $getData');
        return CheckStatusModel.fromJson(jsonDecode(getData.syncData));
      }
      rethrow;
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

//... Save unsve rutin.....///

  Future<Either<String, Message>> saveUnsavedRoutineReq(
      routineId, condition) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/save_unsave/$routineId');
    final headers = {'Authorization': 'Bearer $getToken'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {'saveCondition': '$condition'},
      );

      final res = json.decode(response.body);
      final message = Message.fromJson(res);
      print('from unsaved: $res');

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
