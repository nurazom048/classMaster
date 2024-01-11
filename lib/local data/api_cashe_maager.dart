import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:classmate/local%20data/local_data.dart';

class MyApiCash {
  //
//************************************************************************************* */
//
//................ save Api response With unq key     ...................................//
//
//*************************************************************************************** */

  static void saveLocal({required String key, required String response}) async {
// i also add username to make it uniq to multiple account login
    final String? username = await LocalData.getUsername();

    //
    APICacheDBModel cacheDBModel =
        APICacheDBModel(key: "$key+$username", syncData: response.toString());
    APICacheManager().deleteCache("$key+$username");
    await APICacheManager().addCacheData(cacheDBModel);
  }

// is Have Cash
  static Future<bool> haveCash(String key) async {
    // i also add username to make it uniq to multiple account login
    final String? username = await LocalData.getUsername();
    final bool = await APICacheManager().isAPICacheKeyExist("$key+$username");
    return bool;
  }

  // getData
  static Future<Map<String, dynamic>> getData(String key) async {
    // i also add username to make it uniq to multiple account login
    final String? username = await LocalData.getUsername();
    APICacheDBModel getData =
        await APICacheManager().getCacheData("$key+$username");

    return jsonDecode(getData.syncData);
  }

//******************************************************************* */
//
//................ empty cash     ...................................//
//
//******************************************************************* */
  static Future<void> removeAll() async {
    await APICacheManager().emptyCache();
  }
}
