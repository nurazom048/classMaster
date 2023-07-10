import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';

class MyApiCash {
// save
  static void saveLocal({required String key, required String syncData}) async {
    APICacheDBModel cacheDBModel =
        APICacheDBModel(key: key, syncData: syncData);
    APICacheManager().deleteCache(key);
    await APICacheManager().addCacheData(cacheDBModel);
  }

// is Have Cash
  static Future<bool> haveCash(String key) async {
    final bool = await APICacheManager().isAPICacheKeyExist(key);
    return bool;
  }

  // getData
  static Future<Map<String, dynamic>> getData(String key) async {
    APICacheDBModel getData = await APICacheManager().getCacheData(key);

    return jsonDecode(getData.syncData);
  }

  static Future<void> removeAll() async {
    await APICacheManager().emptyCache();

  }
}
