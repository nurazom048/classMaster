import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/constant/constant.dart';
import '../../core/local data/api_cashe_maager.dart';
import '../../core/local data/local_data.dart';
import '../../features/home_fetures/presentation/utils/utils.dart';
import 'models.dart';

final notificationProvider =
    Provider<NotificationClass>((ref) => NotificationClass());

final classNotificationProvider =
    FutureProvider<ClassNotificationResponse?>((ref) {
  return ref.read(notificationProvider).classNotifications();
});

class NotificationClass {
  Future<ClassNotificationResponse?> classNotifications() async {
    // ignore: avoid_print
    print('call fore notification');

    final Map<String, String> headers = await LocalData.getHeader();

    final url = Uri.parse('${Const.BASE_URl}/class/notification');
    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "notification$url";
    var isHaveCash = await MyApiCache.haveCache(key);
    // ignore: avoid_print
    print(url);
    try {
      // Check if offline and have cache

      if (!isOnline && isHaveCash) {
        var getdata = await MyApiCache.getData(key);
        return ClassNotificationResponse.fromJson(getdata);
      }

      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        final res = json.decode(response.body);

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
