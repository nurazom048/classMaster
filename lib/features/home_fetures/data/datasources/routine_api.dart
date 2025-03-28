// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/local%20data/local_data.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/models/message_model.dart';

class RoutineAPI {
//******    Create Rutins    ********* */
  static Future<Either<Message, Message>> createNewRoutine({
    required String routineName,
  }) async {
    // Obtain shared preferences.
    final header = await LocalData.getHeader();
    final uri = Uri.parse('${Const.BASE_URl}/routine/create');

    final response = await http.post(
      uri,
      body: {"name": routineName.toString()},
      headers: header,
    );

    try {
      final res = json.decode(response.body);
      Message message = Message.fromJson(res);

      //
      if (response.statusCode == 201) {
        // ignore: avoid_print
        print(res);
        return right(
          Message(
            message: message.message,
            routineID: res['routine']['id'],
            routineName: res['routine']['routineName'],
          ),
        );
      } else {
        return left(message);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
