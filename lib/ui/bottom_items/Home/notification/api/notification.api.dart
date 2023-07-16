// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:classmate/models/message_model.dart';

import '../../../../../constant/constant.dart';
import '../../../../../local data/api_cashe_maager.dart';
import '../../utils/utils.dart';
import '../model/notification.model.dart';

final notificationApiProvider =
    Provider<NotificationApi>((ref) => NotificationApi());

final notificationsProvider =
    FutureProvider<Either<Message, NotificationModel>>((ref) async {
  return ref.read(notificationApiProvider).getNotification();
});

class NotificationApi {
  Future<Either<Message, NotificationModel>> getNotification() async {
    final bool isOnline = await Utils.isOnlineMethod();
    String key = 'notification';
    bool isCached = await MyApiCash.haveCash(key);

    Uri uri = Uri.parse('${Const.BASE_URl}/notification');

    try {
      // If offline and have cache
      if (!isOnline && isCached) {
        var cachedData = await APICacheManager().getCacheData(key);
        return Right(
            NotificationModel.fromJson(jsonDecode(cachedData.syncData)));
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Save to cache
        MyApiCash.saveLocal(key: key, syncData: response.body);

        NotificationModel res =
            NotificationModel.fromJson(jsonDecode(response.body));
        print("res: ${jsonDecode(response.body)}");
        return Right(res);
      } else {
        return Left(Message(message: 'Something went wrong'));
      }
    } catch (e) {
      print(e);
      return Left(Message(message: e.toString()));
    }
  }
}
