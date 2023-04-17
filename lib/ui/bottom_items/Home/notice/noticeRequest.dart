// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';

import '../../../../models/notice bord/listOfnotice model.dart';

final viewNoticeByUsernameProvider =
    FutureProvider<Either<String, NoticesResponse>>((ref) async {
  return ref.read(noticeReqProvider).viewNoticeByUsername();
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
}
