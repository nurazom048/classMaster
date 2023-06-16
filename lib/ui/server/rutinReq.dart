// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/class_details_model.dart';

import '../../constant/constant.dart';
import '../bottom_items/Home/utils/utils.dart';

final Rutin_Req_provider = Provider<Rutin_Req>((ref) => Rutin_Req());

//.... Rutins DEtals Provider
final rutins_detalis_provider = FutureProvider.autoDispose
    .family<NewClassDetailsModel?, String>((ref, rutinId) async {
  return ref.read(Rutin_Req_provider).rutins_class_and_priode(rutinId);
});

class Rutin_Req {
  //

  Future<NewClassDetailsModel?> rutins_class_and_priode(String rutinId) async {
    print('*****************************************');

    print(rutinId);

    final String path = "${Const.BASE_URl}/class/$rutinId/all/class";
    final url = Uri.parse(path);
    print(path);

    final bool isOnline = await Utils.isOnlineMethode();
    final String key = "Class-$path";
    final isHaveCache = await APICacheManager().isAPICacheKeyExist(key);

    try {
      // If offline and have cache
      if (isOnline && isHaveCache) {
        final getdata = await APICacheManager().getCacheData(key);
        print('From cache: $getdata');
        return NewClassDetailsModel.fromJson(jsonDecode(getdata.syncData));
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
