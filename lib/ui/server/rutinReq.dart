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

  ///.......... For all Class and priodes........///
  Future<NewClassDetailsModel?> rutins_class_and_priode(String rutinId) async {
    print(rutinId);

    final String path = "${Const.BASE_URl}/class/$rutinId/all/class";
    var url = Uri.parse(path);

    //
    final bool isOnline = await Utils.isOnlineMethode();
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(path);
    try {
      // if offline and have cash
      if (isOnline == false && isHaveCash) {
        var getdata = await APICacheManager().getCacheData(path);
        print('Foem cash $getdata');
        return NewClassDetailsModel.fromJson(jsonDecode(getdata.syncData));

        // if onle fatch new data
      } else {
        final response = await http.get(url);
        var res = json.decode(response.body);
        //  print(res);
        if (response.statusCode == 200) {
          // save to csshe manager
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: path, syncData: response.body);

          await APICacheManager().addCacheData(cacheDBModel);

          //

          var classDetalis = NewClassDetailsModel.fromJson(res);

          return classDetalis;
        } else {
          throw "eror $path";
        }
      }
    } catch (error, stackTrace) {
      print(error.toString());
      return Future.error(error, stackTrace);
    }
  }
}
