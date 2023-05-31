import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/constant.dart';
import '../../../../../models/chack_status_model.dart';
import '../../../../../models/message_model.dart';

final noticeboardRequestProvider =
    Provider<NoticeboardRequest>((ref) => NoticeboardRequest());

class NoticeboardRequest {
// leave member
  Future<Either<Message, Message>> leaveMember(String noticeBoardid) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/notice/members/leave/$noticeBoardid/'),
        headers: {'Authorization': 'Bearer $getToken'},
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
  Future<CheckStatusModel> chackStatus(String noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/status/$noticeBoardId'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      if (response.statusCode == 200) {
        CheckStatusModel res =
            CheckStatusModel.fromJson(jsonDecode(response.body));
        print("res  ${jsonDecode(response.body)}");
        return res;
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //

  Future<Either<String, Message>> sendRequest(String noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/notice/sendRequest/$noticeBoardId");

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

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
  Future<Either<String, Message>> notificationOff(noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url =
        Uri.parse('${Const.BASE_URl}/notice/notification/off/$noticeBoardId');

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
  Future<Either<String, Message>> notificationOn(noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url =
        Uri.parse('${Const.BASE_URl}/notice/notification/on/$noticeBoardId');

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
