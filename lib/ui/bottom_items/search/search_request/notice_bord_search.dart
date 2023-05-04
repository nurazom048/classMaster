import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../helper/constant/constant.dart';
import '../../Home/notice/models/list_noticeboard.dart';

//! provider
final noticeSearchProvider =
    FutureProvider.family<ListOfNoticeBoard, String>((ref, src) async {
  return ref.read(noticeSearchClassProvider).searchNoticeBord(src);
});

///////////////////
class NoticeBordSearchRequest {
//.... NoticeBord Search .....///
  Future<ListOfNoticeBoard> searchNoticeBord(String src) async {
    var url = Uri.parse('${Const.BASE_URl}/notice/seacrh?src=$src');
    try {
      final response = await http.post(url);
      var res = json.decode(response.body);

      print(res);

      if (response.statusCode == 200) {
        return ListOfNoticeBoard.fromJson(json.decode(response.body));
      } else {
        return throw Future.error(res.toString());
      }
    } catch (e) {
      print(e.toString());
      return throw Future.error(e);
    }
  }
}

final noticeSearchClassProvider =
    Provider<NoticeBordSearchRequest>((ref) => NoticeBordSearchRequest());
