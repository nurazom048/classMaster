import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';

final notificationReqProvider =
    Provider<RoutineNotification>((ref) => RoutineNotification());

class RoutineNotification {
  //
  //....RoutineNotification....//
  Future<Either<String, Message>> notificationOff(routineID) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url = Uri.parse('${Const.BASE_URl}/rutin/notification/off/$routineID');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      Message message = Message.fromJson(jsonDecode(response.body));

      /// response
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //....RoutineNotification....//
  Future<Either<String, Message>> notificationOn(routineID) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url = Uri.parse('${Const.BASE_URl}/rutin/notification/on/$routineID');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      Message message = Message.fromJson(jsonDecode(response.body));

      /// response
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
