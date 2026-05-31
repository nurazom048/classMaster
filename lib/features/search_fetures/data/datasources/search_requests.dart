// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constant/constant.dart';
import '../models/search_routine_model.dart';
import '../models/search_account.dart';
import 'package:http/http.dart' as http;

import '../../../home_fetures/presentation/utils/utils.dart';

//! provider
final searchControllersProvider = Provider<SearchRequests>(
  (ref) => SearchRequests(),
);

//
class SearchRequests {
  //! Routine Search
  //.... Routine Search .....///
  Future<SearchRoutinesModel> searchRoutine(String? value, {int? page}) async {
    final String pages = page == null ? '' : '&page=$page';
    var url = Uri.parse('${Const.BASE_URl}/routine/search?src=$value$pages');
    final bool isOnline = await Utils.isOnlineMethod();

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        return SearchRoutinesModel.fromJson(res);
      } else if (isOnline == false) {
        throw Future.error("No Internet Connection");
      } else {
        throw res['message'];
      }
    } catch (e) {
      print(e.toString());
      // throw AsyncValue.error(e, s);
      throw e.toString();
    }
  }
  //! Account Search

  //********* searchAccount   ************ *//

  Future<AccountsResponse> searchAccount(String value, {int? page}) async {
    final String pages = page == null ? '' : '&page=$page';
    var url = Uri.parse('${Const.BASE_URl}/account/find?q=$value$pages');
    final bool isOnline = await Utils.isOnlineMethod();

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        return AccountsResponse.fromJson(res);
      } else if (isOnline == false) {
        throw "No Internet Connection";
      } else {
        throw res;
      }
    } catch (e) {
      rethrow;
    }
  }
}
