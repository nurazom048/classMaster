// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import '../../../core/export_core.dart';
import '../../../core/local data/api_cache_manager.dart';
import '../../home_fetures/presentation/utils/utils.dart';
import '../model/notification.model.dart';

final notificationApiProvider = Provider<NotificationApi>(
  (ref) => NotificationApi(),
);

final notificationsProvider =
    FutureProvider.autoDispose<Either<Message, NotificationModel>>((ref) async {
      return ref.read(notificationApiProvider).getNotification();
    });

class NotificationApi {
  Future<Either<Message, NotificationModel>> getNotification() async {
    final bool isOnline = await Utils.isOnlineMethod();
    const String key = 'notification';
    final bool isCached = await MyApiCache.haveCache(key);
    final Uri uri = Uri.parse('${Const.BASE_URl}/notification');

    try {
      // If offline and have cache
      if (!isOnline && isCached) {
        final cachedData = await MyApiCache.getData(key);
        return Right(NotificationModel.fromJson(cachedData));
      }
      // request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Save to cache
        MyApiCache.saveLocal(key: key, response: response.body);
        final res = NotificationModel.fromJson(jsonDecode(response.body));
        return Right(res);
      } else {
        print(jsonDecode(response.body));
        return Left(Message(message: 'Something went wrong'));
      }
    } catch (e) {
      print(e);
      return Left(Message(message: e.toString()));
    }
  }
}
