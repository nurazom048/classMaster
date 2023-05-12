import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';

final noticeboardMeberRequestProvider =
    Provider<NoticeboardMembersRequest>((ref) {
  return NoticeboardMembersRequest();
});

class NoticeboardMembersRequest {
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
}
