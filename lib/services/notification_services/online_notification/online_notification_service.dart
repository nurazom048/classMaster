import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/constant.dart';
import '../../../core/local_data/api_cache_manager.dart';
import '../../../core/local_data/local_data.dart';
import '../../../features/home_fetures/presentation/utils/utils.dart';
import '../models/notification_models.dart';

final notificationProvider = Provider<NotificationClass>(
  (ref) => NotificationClass(),
);

final classNotificationProvider = FutureProvider<ClassNotificationResponse?>((
  ref,
) {
  return ref.read(notificationProvider).classNotifications();
});

class NotificationClass {
  Future<ClassNotificationResponse?> classNotifications() async {
    final Map<String, String> headers = await LocalData.getHeader();

    final url = Uri.parse('${Const.BASE_URl}/routine/classes/notification');
    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "notification$url";
    var isHaveCash = await MyApiCache.haveCache(key);

    // ignore: avoid_print
    print('📡 [OnlineNotificationService] Fetching class notifications at ${DateTime.now()} from $url (Online: $isOnline)');
    try {
      // Check if offline and have cache
      if (!isOnline && isHaveCash) {
        var getData = await MyApiCache.getData(key);
        // ignore: avoid_print
        print('📦 [OnlineNotificationService] Loaded offline cached notifications');
        return ClassNotificationResponse.fromJson(getData);
      }

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        final res = json.decode(response.body);
        // ignore: avoid_print
        print('✅ [OnlineNotificationService] Received ${(res['allClassForNotification'] as List?)?.length ?? 0} active notification classes');

        // Save to cache
        MyApiCache.saveLocal(key: key, response: response.body);

        return ClassNotificationResponse.fromJson(res);
      } else {
        final res = json.decode(response.body);
        Get.showSnackbar(GetSnackBar(message: '$res'));

        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
