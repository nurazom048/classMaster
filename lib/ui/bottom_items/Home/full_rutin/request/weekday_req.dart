import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
// ignore: unused_import
import 'package:table/models/rutins/class/find_class_model.dart';
import 'package:http/http.dart' as http;

import '../../../../../models/message_model.dart';
import '../../../../../models/rutins/weekday/weekday_list.dart';

final weekdayReqProvider = Provider<WeekdaRequest>((ref) => WeekdaRequest());

//
class WeekdaRequest {
  static Future<Either<Message, WeekdayList>> showWeekdayList(
      String classId) async {
    try {
      final response = await http.get(
        Uri.parse('${Const.BASE_URl}/class/weakday/show/$classId'),
      );

      Message error = Message.fromJson(jsonDecode(response.body));
      WeekdayList wekkdaylist = WeekdayList.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return right(wekkdaylist);
      } else {
        return left(error);
      }
    } catch (e) {
      print(e);
      return left(Message(message: e.toString()));
    }
  }

  //
  static Future<Either<Message, Message>> addWeekday(String classId,
      String? room, String num, String start, String end) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/class/weakday/add/$classId'),
          headers: {'Authorization': 'Bearer $getToken'},
          body: {"num": num, "room": room, "start": start, "end": end});

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return left(res);
      }
    } catch (e) {
      print(e);
      return left(Message(message: e.toString()));
    }
  }

// delete weekday

  static Future<Either<Message, WeekdayList>> deletWeekday(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/class/weakday/delete/$id'),
        headers: {'Authorization': 'Bearer $getToken'},
      );
      Message error = Message.fromJson(jsonDecode(response.body));
      WeekdayList wekkdaylist = WeekdayList.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return right(wekkdaylist);
      } else {
        return left(error);
      }
    } catch (e) {
      print(e);
      return left(Message(message: e.toString()));
    }
  }
}
