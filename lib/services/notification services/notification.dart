import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constant/constant.dart';
import '../../local data/api_cashe_maager.dart';
import '../../local data/local_data.dart';
import '../../ui/bottom_items/Home/utils/utils.dart';
import 'models.dart';

final notificationProvider =
    Provider<NotificationClass>((ref) => NotificationClass());

final classNotificationProvider = FutureProvider<ClassNotificationList?>((ref) {
  return ref.read(notificationProvider).routineNotification();
});

class NotificationClass {
  Future<ClassNotificationList?> routineNotification() async {
    // ignore: avoid_print
    print('call fore notification');

    final Map<String, String> headers = await LocalData.getHerder();

    final url = Uri.parse('${Const.BASE_URl}/class/notification');
    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "notification$url";
    var isHaveCash = await MyApiCash.haveCash(key);
    // ignore: avoid_print
    print(url);
    try {
      // Check if offline and have cache

      if (!isOnline && isHaveCash) {
        var getdata = await MyApiCash.getData(key);
        return ClassNotificationList.fromJson(getdata);
      }

      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        final res = json.decode(response.body);

        // Save to cache

        MyApiCash.saveLocal(key: key, response: response.body);

        return ClassNotificationList.fromJson(res);
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
