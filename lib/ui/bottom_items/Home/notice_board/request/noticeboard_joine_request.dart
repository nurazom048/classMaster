import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/join_request_model.dart';

import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';

// Future Provider
// final noticeBoardReqestListProvider =
//     FutureProvider.family<JoinRequestsResponseModel, String>(
//         (ref, noticeBoardId) async {
//   return ref
//       .read(noticeBoardMemberRequestProvider)
//       .joinedNoticeList(noticeBoardId);
// });

// provider
final noticeBoardMemberRequestProvider =
    Provider<NoticeBaordJoinRequest>((ref) => NoticeBaordJoinRequest());

class NoticeBaordJoinRequest {
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

    print(res);

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

  //...acceptRequest.....//
  Future<Message> acceptRequest(String noticeBoardid, String userID) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse(
            '${Const.BASE_URl}/notice/acceptRequest/$noticeBoardid/$userID'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      print(e);
      return Message(message: e.toString());
    }
  }

  //...acceptRequest.....//
  Future<Message> rejectRequest(String noticeBoardid, String userID) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse(
            '${Const.BASE_URl}/notice/rejectRequest/$noticeBoardid/$userID'),
        headers: {'Authorization': 'Bearer $getToken'},
      );
      print("${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        return Message.fromJson(jsonDecode(response.body));
      } else {
        return Message.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
      return Message(message: e.toString());
    }
  }
}
