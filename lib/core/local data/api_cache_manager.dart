import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:classmate/core/local%20data/local_data.dart';

class MyApiCache {
  static const String boxName = "apiCache";

  static Future<void> saveLocal(
      {required String key, required String response}) async {
    final String? username = await LocalData.getUsername();
    final cacheKey = "$key+$username";
    var box = await Hive.openBox(boxName);
    await box.put(cacheKey, response);
  }

  static Future<bool> haveCache(String key) async {
    final String? username = await LocalData.getUsername();
    final cacheKey = "$key+$username";
    var box = await Hive.openBox(boxName);
    return box.containsKey(cacheKey);
  }

  static Future<Map<String, dynamic>> getData(String key) async {
    final String? username = await LocalData.getUsername();
    final cacheKey = "$key+$username";
    var box = await Hive.openBox(boxName);
    return jsonDecode(box.get(cacheKey));
  }

  static Future<void> removeAll() async {
    var box = await Hive.openBox(boxName);
    await box.clear();
  }
}
