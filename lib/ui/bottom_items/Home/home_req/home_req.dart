// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/constant.dart';
import '../../../../local data/api_cashe_maager.dart';
import '../../../../local data/local_data.dart';
import '../../../../models/message_model.dart';
import '../../../../models/Routine/saveRutine.dart';
import '../models/home_routines_model.dart';
import '../utils/utils.dart';

//!.. Provider ...!//

final home_req_provider = Provider<HomeReq>((ref) => HomeReq());

class HomeReq {
//************************************************************************************/
//---------------------- saveRoutines Api Request  -----------------------------------/
//************************************************************************************/
  Future<SaveRutileResponse> saveRoutines({pages}) async {
    String queryPage = "?page=$pages}";
    String? username = "";
    final headers = await LocalData.getHerder();

    final url = Uri.parse(
        '${Const.BASE_URl}/rutin/save/routines/' + username + queryPage);

    //.. Request send
    try {
      final response = await http.post(url, headers: headers);
      print(json.decode(response.body));

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        print(res);

        return SaveRutileResponse.fromJson(res);
      } else {
        throw "Failed to load saved routines";
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
//************************************************************************************/
//---------------------- Home Routines Api Request  -----------------------------------/
//************************************************************************************/

  Future<RoutineHome> homeRoutines({pages, String? userID}) async {
    String queryPage = "?page=$pages";
    final searchByUserID = userID == null ? '' : '/$userID';
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    // var status = await OneSignal.shared.getDeviceState();

    //String? tokenId = status?.pushToken;
    print("osUserID Home : $osUserID");

    final url =
        Uri.parse('${Const.BASE_URl}/rutin/home' + searchByUserID + queryPage);
    final headers = await LocalData.getHerder();
    final bool isOffline = await Utils.isOnlineMethod();
    final String key = "HomeRoutine_offline_data_$url";
    final bool isHaveCash = await MyApiCash.haveCash(key);
    // print("isOffline : ${!isOffline} && isHaveCash: $isHaveCash");

    try {
      // if offline and have cash
      if (!isOffline && isHaveCash) {
        Get.snackbar('offline', "Failed to load new data ");
        var getdata = await MyApiCash.getData(key);
        print('From cash $url');
        return RoutineHome.fromJson(getdata);
      }

      //
      final response = await http
          .post(url, headers: headers, body: {"osUserID": osUserID ?? ''});
      print(response);

      //
      final res = json.decode(response.body);

      print(res);

      if (response.statusCode == 200) {
        RoutineHome homeRutine = RoutineHome.fromJson(res);

        // save to local offline
        if (userID == null) {
          MyApiCash.saveLocal(key: key, response: response.body);
        }

        return homeRutine;
      } else if (!isOffline) {
        Get.snackbar('Connection failed', "No Internet Connection");

        throw "No Internet Connection";
      } else {
        Get.snackbar('failed', "Failed to load new data ");
        if (isHaveCash) {
          var getdata = await MyApiCash.getData(key);
          return RoutineHome.fromJson(getdata);
        }

        throw "${res["message"]}";
      }
    } catch (e) {
      Get.snackbar('error', "$e");
      throw "$e";
    }
  }
//************************************************************************************/
//---------------------- DeleteRoutine Api Request  -----------------------------------/
//************************************************************************************/

  Future<Either<Message, Message>> deleteRutin(rutin_id) async {
    final headers = await LocalData.getHerder();

    var url = Uri.parse("${Const.BASE_URl}/rutin/$rutin_id");

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var res = Message.fromJson(jsonDecode(response.body));
        print("req from delete req ${res.message}");

        return right(Message(
          message: res.message,
          routineID: rutin_id,
        ));
      } else {
        var res = Message.fromJson(jsonDecode(response.body));
        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
