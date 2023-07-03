import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:api_cache_manager/utils/cache_manager.dart';

import '../../constant/constant.dart';
import '../../ui/auth_Section/auth_controller/auth_controller.dart';
import '../../ui/bottom_items/Home/utils/utils.dart';
import 'models.dart';

final notificationProvider =
    Provider<NotificationClass>((ref) => NotificationClass());

final classNotificationProvider =
    FutureProvider.autoDispose<ClassNotificationList?>((ref) {
  return ref.read(notificationProvider).routineNotification();
});

class NotificationClass {
  Future<ClassNotificationList?> routineNotification() async {
    // ignore: avoid_print
    print('call fore notification');

    final String? getToken = await AuthController.getToken();

    final url = Uri.parse('${Const.BASE_URl}/class/notification');
    final headers = {'Authorization': 'Bearer $getToken'};
    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "notification$url";
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(key);
    // ignore: avoid_print
    print(url);
    try {
      // Check if offline and have cache
      if (!isOnline && isHaveCash) {
        var cacheData = await APICacheManager().getCacheData(key);
        return ClassNotificationList.fromJson(json.decode(cacheData.syncData));
      }

      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        // Save to cache
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: key, syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        return ClassNotificationList.fromJson(res);
      } else {
        final res = json.decode(response.body);
        Get.showSnackbar(GetSnackBar(message: '$res'));

        return null;
      }
    } catch (e) {
      if (isHaveCash) {
        var cacheData = await APICacheManager().getCacheData(key);
        return ClassNotificationList.fromJson(json.decode(cacheData.syncData));
      }
      Get.showSnackbar(GetSnackBar(message: 'Error $e'));
    }

    return null;
  }
}
