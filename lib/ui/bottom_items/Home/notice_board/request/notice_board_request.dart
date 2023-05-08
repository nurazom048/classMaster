// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/constant.dart';
import '../models/list_noticeboard.dart';

//
final uploadedNoticeBoardProvider =
    FutureProvider<ListOfNoticeBoard>((ref) async {
  return ref.read(noticeBoardRequestProvider).uploadedNoticeBoard();
});

final noticeBoardRequestProvider =
    Provider<NoticeBoardRequest>((ref) => NoticeBoardRequest());

class NoticeBoardRequest {
  //******    createTedNoticeBoardNAme    ********* */
  Future<ListOfNoticeBoard> uploadedNoticeBoard() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/all_notice_board'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        return ListOfNoticeBoard.fromJson(res);
      } else {
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      print(e);
      return throw Future.error(e);
    }
  }

  //******    joinedNoticeList    ********* */
  static Future<ListOfNoticeBoard> joinedNoticeList() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/all_notice_board'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        print(res);
        return ListOfNoticeBoard.fromJson(res);
      } else {
        //
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      return throw Future.error(e);
    }
  }
}
