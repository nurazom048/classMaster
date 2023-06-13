// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/rutins/list_of_save_rutin.dart';
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
  //********    ListOfUploedRutins      *************/
  Future<ListOfUploadedRutins> uplodedRutins({String? username}) async {
    final prams = username != null ? '/$username' : '';
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/uploded_rutins' + prams);
    final headers = {'Authorization': 'Bearer $getToken'};

    //.. Request send

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        print(res);

        return ListOfUploadedRutins.fromJson(res);
      } else {
        throw Exception("Failed to load saved routines");
      }
    } catch (error) {
      throw Future.error(error);
    }
  }

  //********    homeRutines      *************/

  Future<HomeRoutines> homeRutines({pages}) async {
    String queryPage = "?page=$pages}";
    String? username = "";
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/home/' + queryPage);
    final headers = {'Authorization': 'Bearer $getToken'};
    final bool isOnline = await Utils.isOnlineMethode();
    var isHaveCash = await APICacheManager().isAPICacheKeyExist("homeRutines");
    try {
      // if offline and have cash
      if (isOnline == false && isHaveCash) {
        var getdata = await APICacheManager().getCacheData("homeRutines");
        print('Foem cash $getdata');
        return HomeRoutines.fromJson(jsonDecode(getdata.syncData));
      }

      //
      final response = await http.post(url, headers: headers);

      //
      final res = json.decode(response.body);
      print(res);

      HomeRoutines homeRutines = HomeRoutines.fromJson(res);

      if (response.statusCode == 200) {
        // save to csh
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: "homeRutines", syncData: response.body);

        await APICacheManager().addCacheData(cacheDBModel);

        return homeRutines;
      } else {
        throw Future.error("eror");
      }
    } catch (e) {
      print(e);

      return Future.error("$e  $isOnline");
    }
  }
}
