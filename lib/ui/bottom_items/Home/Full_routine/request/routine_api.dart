// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/class_details_model.dart';

import '../../../../../constant/constant.dart';
import '../../utils/utils.dart';

final routine_Req_provider = Provider<Routine_Req>((ref) => Routine_Req());

//.... routine_details_provider
final routine_details_provider = FutureProvider.autoDispose
    .family<NewClassDetailsModel?, String>((ref, routineId) async {
  return ref.read(routine_Req_provider).routine_class_and_priode(routineId);
});

class Routine_Req {
  //

  Future<NewClassDetailsModel?> routine_class_and_priode(
      String routineId) async {
    print('*****************************************');

    print(routineId);

    final String path = "${Const.BASE_URl}/class/$routineId/all/class";
    final url = Uri.parse(path);
    print(path);

    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "Class-$path";
    final isHaveCache = await APICacheManager().isAPICacheKeyExist(key);

    try {
      // If offline and have cache
      if (!isOnline && isHaveCache) {
        final getData = await APICacheManager().getCacheData(key);
        print('From cache: $getData');
        return NewClassDetailsModel.fromJson(jsonDecode(getData.syncData));
      } else {
        final response = await http.get(url);
        final res = json.decode(response.body);
        print(res);
        if (response.statusCode == 200) {
          // Save to cache manager
          final cacheDBModel =
              APICacheDBModel(key: key, syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);

          final classDetails = NewClassDetailsModel.fromJson(res);
          return classDetails;
        } else {
          throw "error $path";
        }
      }
    } catch (error, stackTrace) {
      print(error.toString());
      return Future.error(error, stackTrace);
    }
  }
}
