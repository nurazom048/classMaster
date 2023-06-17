// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/constant.dart';
import '../../../../models/rutins/saveRutine.dart';
import '../models/home_rutines_model.dart';
import '../utils/utils.dart';

//!.. Provider ...!//

final home_req_provider = Provider<HomeReq>((ref) => HomeReq());

final save_rutins_provider =
    FutureProvider.family<SaveRutineResponse, int>((ref, page) {
  return ref.read(home_req_provider).savedRutins(pages: page);
});

class HomeReq {
//********    savedRutins      *************/
  Future<SaveRutineResponse> savedRutins({pages}) async {
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

        return SaveRutineResponse.fromJson(res);
      } else {
        throw Exception("Failed to load saved routines");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //
  // //********    ListOfUploedRutins      *************/
  // Future<ListOfUploadedRutins> uplodedRutins({String? username}) async {
  //   final prams = username != null ? '/$username' : '';
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');
  //   final url = Uri.parse('${Const.BASE_URl}/rutin/uploded_rutins' + prams);
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

  //********    homeRutines      *************/

  Future<RoutineHome> homeRutines({pages, String? userID}) async {
    String queryPage = "?page=$pages";
    final searchByUserID = userID == null ? '' : '/$userID';
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final url =
        Uri.parse('${Const.BASE_URl}/rutin/home' + searchByUserID + queryPage);
    final headers = {'Authorization': 'Bearer $getToken'};
    final bool isOnline = await Utils.isOnlineMethode();
    final String key = "homeRutines$url";
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(key);
    print(url);
    try {
      // // if offline and have cash
      if (isOnline && isHaveCash) {
        var getdata = await APICacheManager().getCacheData(key);
        print('Foem cash $url');
        return RoutineHome.fromJson(jsonDecode(getdata.syncData));
      }

      //
      final response = await http.post(url, headers: headers);

      //
      final res = json.decode(response.body);
      print(' Home *******************');

      print(res);
      print(response.statusCode);
      print('$isOnline 5 $isHaveCash');

      if (response.statusCode == 200) {
        RoutineHome homeRutines = RoutineHome.fromJson(res);

        // save to csh
        if (userID == null) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: key, syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
        }
        print('&&&&&&&&&&&    Indise 200');

        return homeRutines;
      } else if (isOnline) {
        throw "No Internet Connection";
      } else {
        throw "${res["message"]}";
      }
    } catch (e) {
      print(e);
      throw "$e";
    }
  }
}
