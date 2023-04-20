// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/notice%20bord/ceatedNoticeBordName.dart';

import '../../../../models/notice bord/listOfnotice model.dart';
import '../../../../models/notice bord/recentNotice.dart';

final viewNoticeByUsernameProvider =
    FutureProvider<Either<String, NoticesResponse>>((ref) async {
  return ref.read(noticeReqProvider).viewNoticeByUsername();
});

// recet notice
final recentNoticeProvider =
    FutureProvider<Either<String, RecentNotice>>((ref) async {
  return ref.read(noticeReqProvider).recentNotice();
});

// recet notice
final createdNoticeBoardNmae =
    FutureProvider<CreatedNoticeBoardByMe>((ref) async {
  return ref.read(noticeReqProvider).cretedNoticeBoardNAme();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

class NoticeRequest {
//******    view All notice by username    ********* */
  Future<Either<String, NoticesResponse>> viewNoticeByUsername() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.get(Uri.parse('${Const.BASE_URl}/notice/qq'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        print(res);
        return right(NoticesResponse.fromJson(res));
      } else {
        return left("error");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //******    recentNotice    ********* */
  Future<Either<String, RecentNotice>> recentNotice() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/recent'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        print(res);
        return right(RecentNotice.fromJson(res));
      } else {
        return left("error");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //******    createTedNoticeBoardNAme    ********* */
  Future<CreatedNoticeBoardByMe> cretedNoticeBoardNAme() async {
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
        return CreatedNoticeBoardByMe.fromJson(res);
      } else {
        throw "";
      }
    } catch (e) {
      throw e;
    }
  }
}
