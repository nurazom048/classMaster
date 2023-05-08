import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';

final notificationReqProvider =
    Provider<RutineNotification>((ref) => RutineNotification());

class RutineNotification {
  //
  //....RutineNotification....//
  Future<Either<String, Message>> notificationOff(rutineId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url = Uri.parse('${Const.BASE_URl}/rutin/notification/off/$rutineId');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      Message message = Message.fromJson(jsonDecode(response.body));

      /// responce
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //....RutineNotification....//
  Future<Either<String, Message>> notificationOn(rutineId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url = Uri.parse('${Const.BASE_URl}/rutin/notification/on/$rutineId');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      Message message = Message.fromJson(jsonDecode(response.body));

      /// responce
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
