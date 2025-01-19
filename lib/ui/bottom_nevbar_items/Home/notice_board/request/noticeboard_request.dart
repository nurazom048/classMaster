// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/constant.dart';
import '../../../../../core/local data/local_data.dart';
import '../../../../../models/check_status_model.dart';
import '../../../../../models/message_model.dart';

final noticeboardRequestProvider =
    Provider<NoticeboardRequest>((ref) => NoticeboardRequest());

class NoticeboardRequest {
// leave member
  Future<Either<Message, Message>> leaveMember(String noticeBoard) async {
    final headers = await LocalData.getHerder();

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/notice/leave/$noticeBoard'),
        headers: headers,
      );

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return right(res);
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //
  Future<CheckStatusModel> chackStatus(String academyID) async {
    final headers = await LocalData.getHerder();

    var url = Uri.parse('${Const.BASE_URl}/notice/status/$academyID');

    try {
      final response = await http.post(
        url,
        headers: headers,
      );
      print("res  ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        CheckStatusModel res =
            CheckStatusModel.fromJson(jsonDecode(response.body));
        print("res  ${jsonDecode(response.body)}");
        return res;
      } else {
        throw Exception("Soothing went Wrong");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //

  Future<Either<String, Message>> sendRequest(String noticeBoardId) async {
    final headers = await LocalData.getHerder();

    var url = Uri.parse("${Const.BASE_URl}/notice/join/$noticeBoardId");

    try {
      final response = await http.post(
        url,
        headers: headers,
      );

      var res = Message.fromJson(jsonDecode(response.body));
      print("req from  sendRequest $res");

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return right(res);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //
  //....RutineNotification....//
  Future<Either<String, Message>> notificationOff(String routineID) async {
    final headers = await LocalData.getHerder();
    Uri url = Uri.parse('${Const.BASE_URl}/notice/notification/off/$routineID');

    try {
      final response = await http.post(
        url,
        headers: headers,
      );
      Message message = Message.fromJson(jsonDecode(response.body));

      /// response
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
  Future<Either<String, Message>> notificationOn(String routineID) async {
    final headers = await LocalData.getHerder();
    print('RutineNotification $routineID');
    Uri url = Uri.parse('${Const.BASE_URl}/notice/notification/on/$routineID');

    try {
      final response = await http.post(
        url,
        headers: headers,
      );
      Message message = Message.fromJson(jsonDecode(response.body));

      /// response
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
