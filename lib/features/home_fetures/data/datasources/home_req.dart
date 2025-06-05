// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constant/constant.dart';
import '../../../../core/local data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../routine_Fetures/data/models/save_routine.dart';
import '../../presentation/utils/utils.dart';
import '../models/home_routines_model.dart';

//!.. Provider ...!//

final home_req_provider = Provider<HomeReq>((ref) => HomeReq());

class HomeReq {
  //************************************************************************************/
  //---------------------- saveRoutines Api Request  -----------------------------------/
  //************************************************************************************/
  Future<SaveRutileResponse> saveRoutines({pages}) async {
    String queryPage = "?page=$pages}";
    String? username = "";
    final headers = await LocalData.getHeader();

    final url = Uri.parse(
      '${Const.BASE_URl}/routine/save/routines/' + username + queryPage,
    );

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

    final url = Uri.parse(
      '${Const.BASE_URl}/routine/home' + searchByUserID + queryPage,
    );
    final headers = await LocalData.getHeader();

    // Check online status
    final bool isOffline = !await Utils.isOnlineMethod();
    final String key = "HomeRoutine_offline_data_$url";

    // Open Hive box for caching
    var routineCacheBox = await Hive.openBox('routineCache');

    try {
      // Check if data is already cached in Hive
      if (isOffline) {
        if (routineCacheBox.containsKey(key)) {
          Get.snackbar('Offline Mode', "Loading cached data...");
          var cachedData = routineCacheBox.get(key);
          print('Loaded from Hive cache: $url');
          return RoutineHome.fromJson(json.decode(cachedData));
        } else {
          throw "No cached data available.";
        }
      }

      // Fetch data from API if online
      final response = await http.post(url, headers: headers);
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        RoutineHome homeRoutine = RoutineHome.fromJson(res);

        // Save the response in Hive cache
        await routineCacheBox.put(key, response.body);
        print('Data saved in Hive cache');

        return homeRoutine;
      } else {
        throw "${res["message"]}";
      }
    } catch (e) {
      Get.snackbar('Error', "$e");
      throw "$e";
    }
  }

  //************************************************************************************/
  //---------------------- DeleteRoutine Api Request  -----------------------------------/
  //************************************************************************************/

  Future<Either<Message, Message>> deleteRoutine(rutin_id) async {
    final headers = await LocalData.getHeader();

    var url = Uri.parse("${Const.BASE_URl}/routine/$rutin_id");

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        var res = Message.fromJson(jsonDecode(response.body));
        print("req from delete req ${res.message}");

        return right(Message(message: res.message, routineID: rutin_id));
      } else {
        var res = Message.fromJson(jsonDecode(response.body));
        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
