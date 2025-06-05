// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/constant.dart';
import '../../../../core/local data/api_cache_manager.dart';
import '../../../../../features/home_fetures/presentation/utils/utils.dart';
import '../models/class_details_model.dart';

final routine_Req_provider = Provider<Routine_Req>((ref) => Routine_Req());

class Routine_Req {
  //

  Future<AllClassesResponse?> all_class_in_routine(String routineId) async {
    //
    final bool isOnline = await Utils.isOnlineMethod();
    final String path = "${Const.BASE_URl}/class/$routineId/all/class";
    final url = Uri.parse(path);
    final String key = "Class-$path";
    final isHaveCache = await MyApiCache.haveCache(key);

    try {
      // If offline and have cache
      if (!isOnline && isHaveCache) {
        final getData = await MyApiCache.getData(key);
        return AllClassesResponse.fromJson(getData);
      } else {
        final response = await http.get(url);
        final res = json.decode(response.body);
        print(res);
        if (response.statusCode == 200) {
          // Save to cache manager
          MyApiCache.saveLocal(key: key, response: response.body);

          final classDetails = AllClassesResponse.fromJson(res);
          return classDetails;
        } else {
          throw "error ${res['message']}";
        }
      }
    } catch (error) {
      if (isHaveCache) {
        final getData = await MyApiCache.getData(key);
        return AllClassesResponse.fromJson(getData);
      }
      rethrow;
    }
  }
}
