// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/constant.dart';
import '../../../../models/message_model.dart';
import '../../../../models/Routine/saveRutine.dart';
import '../models/home_routines_model.dart';
import '../utils/utils.dart';

//!.. Provider ...!//

final home_req_provider = Provider<HomeReq>((ref) => HomeReq());

class HomeReq {
//********    saveRoutines      *************/
  Future<SaveRutileResponse> saveRoutines({pages}) async {
    String queryPage = "?page=$pages}";
    String? username = "";
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse(
        '${Const.BASE_URl}/rutin/save_rutins/' + username + queryPage);
    final headers = {'Authorization': 'Bearer $getToken'};

    //.. Request send
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);

        return SaveRutileResponse.fromJson(res);
      } else {
        throw Exception("Failed to load saved routines");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //
  // //********    ListOfUploadRutins      *************/
  // Future<ListOfUploadedRutins> uploadedRutins({String? username}) async {
  //   final prams = username != null ? '/$username' : '';
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');
  //   final url = Uri.parse('${Const.BASE_URl}/rutin/uploaded_rutins' + prams);
  //   final headers = {'Authorization': 'Bearer $getToken'};

  //   //.. Request send

  //   try {
  //     final response = await http.post(url, headers: headers);

  //     if (response.statusCode == 200) {
  //       var res = json.decode(response.body);
  //       print(res);

  //       return ListOfUploadedRutins.fromJson(res);
  //     } else {
  //       throw Exception("Failed to load saved routines");
  //     }
  //   } catch (error) {
  //     throw Future.error(error);
  //   }
  // }

  //********    home Routines      *************/

  Future<RoutineHome> homeRoutines({pages, String? userID}) async {
    String queryPage = "?page=$pages";
    final searchByUserID = userID == null ? '' : '/$userID';
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    // var status = await OneSignal.shared.getDeviceState();
    print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
    //String? tokenId = status?.pushToken;
    print("osUserID : $osUserID");

    final url =
        Uri.parse('${Const.BASE_URl}/rutin/home' + searchByUserID + queryPage);
    final headers = {'Authorization': 'Bearer $getToken'};
    final bool isOffline = await Utils.isOnlineMethod();
    final String key = "homeRutines$url";
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(key);
    try {
      // print('kjdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
      // print(userID);
      // print(isHaveCash);
      // print(!isOffline);
      // // if offline and have cash
      if (!isOffline && isHaveCash) {
        Get.snackbar('offline', "Failed to load new data ");
        var getdata = await APICacheManager().getCacheData(key);
        print('From cash $url');
        return RoutineHome.fromJson(jsonDecode(getdata.syncData));
      }

      //
      final response = await http
          .post(url, headers: headers, body: {"osUserID": osUserID ?? ''});

      //
      final res = json.decode(response.body);

      // print(res);
      // print(response.statusCode);
      // print('$isOffline 5 $isHaveCash');

      if (response.statusCode == 200) {
        RoutineHome homeRutine = RoutineHome.fromJson(res);

        // save to csh
        if (userID == null) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: key, syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
        }

        return homeRutine;
      } else if (!isOffline) {
        Get.snackbar('Connection failed', "No Internet Connection");

        throw "No Internet Connection";
      } else {
        Get.snackbar('failed', "Failed to load new data ");
        if (isHaveCash) {
          var getdata = await APICacheManager().getCacheData(key);
          print('From cash $url');
          return RoutineHome.fromJson(jsonDecode(getdata.syncData));
        }

        throw "${res["message"]}";
      }
    } catch (e) {
      Get.snackbar('failed', "$e");

      if (isHaveCash) {
        var getdata = await APICacheManager().getCacheData(key);
        print('From cash $url');
        return RoutineHome.fromJson(jsonDecode(getdata.syncData));
      }
      throw "$e";
    }
  }

  // DELETE ROUTINE

  //...... Delete Rutin.....//

  Future<Either<Message, Message>> deleteRutin(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/rutin/$rutin_id");

    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});

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
