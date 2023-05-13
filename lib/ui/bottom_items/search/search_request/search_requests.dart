import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/constant.dart';
import '../../../../models/rutins/search_rutin.dart';
import '../../../../models/search_account.dart';
import 'package:http/http.dart' as http;

import '../../Home/notice_board/models/list_noticeboard.dart';

//! provider
final searchControllersProvider = Provider<SearchRequests>((ref) {
  return SearchRequests();
});

//
class SearchRequests {
//! Rutine Search
//.... Rutin Search .....///
  Future<RutinQuarry> searchRoutine(String? valu) async {
    print("valu pici vai : $valu");
    //  var url = Uri.parse('${Const.BASE_URl}/rutin/search?src=$valu');
    var url = Uri.parse('${Const.BASE_URl}/rutin/search?src=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
        return RutinQuarry.fromJson(res);
      } else {
        throw Exception(res);
      }
    } catch (e) {
      print(e.toString());
      throw Future.error(e);
    }
  }
//! Account Search

  //********* searchAccount   ************ *//

  Future<AccountsResponse> searchAccount(String valu) async {
    print("valu pici vai : $valu");
    var url = Uri.parse('${Const.BASE_URl}/account/find?q=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        return AccountsResponse.fromJson(res);
      } else {
        throw Exception(res);
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

//! Noticeboard Search

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
      // ignore: avoid_print
      print(e.toString());
      return throw Future.error(e);
    }
  }
}
