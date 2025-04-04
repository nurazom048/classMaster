import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import '../../../../core/export_core.dart';
import '../../../../core/local data/local_data.dart';
import '../models/weekday_list.dart';
import '../../presentation/utils/popup.dart';

final weekdayReqProvider = Provider<WeekdayRequest>((ref) => WeekdayRequest());

//
class WeekdayRequest {
  static Future<WeekdayList> showWeekdayList(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('${Const.BASE_URl}/class/weekday/show/$classId'),
      );
      Message error = Message.fromJson(jsonDecode(response.body));
      WeekdayList weekdayList = WeekdayList.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        //print(jsonDecode(response.body));
        return weekdayList;
      } else {
        throw Future.error(error);
      }
    } catch (error) {
      throw Future.error(error);
    }
  }

  //
  static Future<Either<Message, Message>> addWeekday(
    String classId,
    String room,
    String day,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final headers = await LocalData.getHeader();
    final uri = Uri.parse('${Const.BASE_URl}/class/weekday/$classId');

    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: {
          "day": day,
          "room": room,
          "startTime": endMaker(startTime.toIso8601String().toString()),
          "endTime": endMaker(endTime.toIso8601String().toString()),
        },
      );

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

// delete weekday

  static Future<Either<Message, WeekdayList>> deleteWeekday(
      String id, String classID) async {
    final headers = await LocalData.getHeader();

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/class/weekday/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        WeekdayList weekdayList =
            WeekdayList.fromJson(jsonDecode(response.body));

        return right(weekdayList);
      } else {
        return left(Message.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
