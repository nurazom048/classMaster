import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';
import '../models/join_request_model.dart';

// Future Provider
final noticeBoardReqestListProvider =
    FutureProvider.family<JoinRequestsResponseModel, String>(
        (ref, noticeBoardId) async {
  return ref
      .read(noticeBoardJoinRequestProvider)
      .joinedNoticeList(noticeBoardId);
});

//
final noticeBoardJoinRequestProvider =
    Provider<NoticeBoardJoinRequest>((ref) => NoticeBoardJoinRequest());

class NoticeBoardJoinRequest {
  //******    see all joined request     ********* */
  Future<JoinRequestsResponseModel> joinedNoticeList(
      String noticeBoardId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.get(
        Uri.parse('${Const.BASE_URl}/notice/viewRequest/$noticeBoardId'),
        headers: {'Authorization': 'Bearer $getToken'});
    final res = json.decode(response.body);
    JoinRequestsResponseModel list = JoinRequestsResponseModel.fromJson(res);

    try {
      if (response.statusCode == 200) {
        return list;
      } else {
        //
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      print(e);
      return throw Future.error(e);
    }
  }
}
