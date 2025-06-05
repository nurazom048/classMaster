// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:classmate/core/local%20data/api_cache_manager.dart';
import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import '../../../../../core/local data/local_data.dart';
import '../../../../core/export_core.dart';
import '../models/check_status_model.dart';

//*** Providers  ******   */
final fullRoutineProvider = Provider((ref) => FullRoutineRequest());

class FullRoutineRequest {
  //
  //....Check StatusModel....//
  Future<CheckStatusModel> chalkStatus(routineId) async {
    final bool isOnline = await Utils.isOnlineMethod();
    final key = "chalkStatus$routineId";
    final bool isHaveCash = await MyApiCache.haveCache(key);
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/routine/status/$routineId');

    try {
      // if offline and have cash
      if (!isOnline && isHaveCash) {
        Map<String, dynamic> getData = await MyApiCache.getData(key);
        print('from cash $getData');
        return CheckStatusModel.fromJson(getData);
      } else if (!isOnline) {
        throw "You Are in Offline";
      } else {
        final response = await http.post(url, headers: headers);

        if (response.statusCode == 200) {
          // print(jsonDecode(response.body));
          // save to csh

          MyApiCache.saveLocal(key: key, response: response.body);

          CheckStatusModel res = CheckStatusModel.fromJson(
            jsonDecode(response.body),
          );
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
        var getData = await MyApiCache.getData(key);
        return CheckStatusModel.fromJson(getData);
      }
      rethrow;
    }
  }

  //,, delete class
  Future<Message> deleteClass(context, classId) async {
    final headers = await LocalData.getHeader();

    var url = Uri.parse('${Const.BASE_URl}/class/delete/$classId');

    try {
      final response = await http.delete(url, headers: headers);
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

  //... Save unSave routine.....///

  Future<Either<String, Message>> saveUnsavedRoutineReq(
    routineId,
    condition,
  ) async {
    final headers = await LocalData.getHeader();

    final url = Uri.parse('${Const.BASE_URl}/routine/save_unsave/$routineId');

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
