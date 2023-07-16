import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant/constant.dart';
import '../../../../../local data/local_data.dart';
import '../../../../../models/message_model.dart';
import '../../../../../models/Routine/weekday/weekday_list.dart';

final weekdayReqProvider = Provider<WeekdayRequest>((ref) => WeekdayRequest());

//
class WeekdayRequest {
  static Future<WeekdayList> showWeekdayList(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('${Const.BASE_URl}/class/weakday/show/$classId'),
      );
      Message error = Message.fromJson(jsonDecode(response.body));
      WeekdayList weekdayList = WeekdayList.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
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
    String? room,
    String num,
    String start,
    String end,
  ) async {
    final headers = await LocalData.getHerder();

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/class/weakday/add/$classId'),
          headers: headers,
          body: {"num": num, "room": room, "start": start, "end": end});

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
    final headers = await LocalData.getHerder();

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/class/weakday/delete/$id/$classID'),
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
