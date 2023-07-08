// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/priode/all_priode_models.dart';

import '../../../../../constant/constant.dart';
import '../../../Add/screens/add_priode.dart';
import '../../utils/utils.dart';

//... provider...//
final priodeRequestProvider = Provider<PriodeRequest>((ref) => PriodeRequest());

class PriodeRequest {
//... Delete  Priode request....//

  Future<Either<String, Message>> deletePriode(String priodeId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/priode/remove/$priodeId');

    try {
      // request

      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        Message message = Message.fromJson(res);

        return right(message);
      } else {
        Message message = Message.fromJson(res);

        return left(message.message);
      }
    } catch (e) {
      print(e);
      return left(e.toString());
    }
  }

  //
  //... add priode....//
  Future<Either<String, Message>> addPriode(
      String routineID, DateTime startTime, DateTime endTime) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/add/$routineID');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
          "start_time": "${startTime.toIso8601String()}Z",
          "end_time": "${endTime.toIso8601String()}Z",
        },
      );

      var res = json.decode(response.body);
      print(res);
      Message message = Message.fromJson(res);

      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      print("s $e");
      return left(e.toString());
    }
  }

  ///
  ///
  /// GET : All Priode In Routine
  Future<Either<Message, AllPriodeList>> allPriode(String routineID) async {
    final url = Uri.parse('${Const.BASE_URl}/rutin/all_priode/$routineID');

    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "Priodes-$url";
    final isHaveCache = await APICacheManager().isAPICacheKeyExist(key);

    try {
      print('******************');
      print('$isOnline $isHaveCache');
      // If user is offline, load data from cache
      if (!isOnline && isHaveCache) {
        final getdata = await APICacheManager().getCacheData(key);
        print('From cache: $getdata');
        return Right(AllPriodeList.fromJson(jsonDecode(getdata.syncData)));
      }
      //
      final response = await http.get(url);
      final res = json.decode(response.body);
      print(res);
      final message = Message.fromJson(res);
      final allPriode = AllPriodeList.fromJson(res);

      if (response.statusCode == 200) {
        // When success, save data into cache
        final cacheDBModel = APICacheDBModel(key: key, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        // Return the response
        return Right(allPriode);
      } else {
        return Left(message);
      }
    } catch (e) {
      print("Error: $e");
      return Left(Message(message: e.toString()));
    }
  }

  Future<Either<Message, AllPriode>> findPriodesYid(String priodeId) async {
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/find/$priodeId');

    try {
      final response = await http.get(url);

      var res = json.decode(response.body);

      AllPriode priode = AllPriode.fromJson(res);

      if (response.statusCode == 200) {
        return right(priode);
      } else {
        return right(priode);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //... add priode....//
  Future<Either<String, Message>> edditPriode(
      String priodeId, DateTime startTime, DateTime endTime) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/eddit/$priodeId');

    try {
      final response = await http.put(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
          "start_time": endMaker(startTime.toIso8601String().toString()),
          "end_time": endMaker(endTime.toIso8601String().toString()),
        },
      );

      var res = json.decode(response.body);
      print(res);
      Message message = Message.fromJson(res);

      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      print("s $e");
      return left(e.toString());
    }
  }
}
