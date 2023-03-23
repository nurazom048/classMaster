// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

import '../../../../models/Account_models.dart';

final AccountReqProvider = Provider<AccountReq>((ref) {
  return AccountReq();
});
//
final accountDataProvider = FutureProvider.autoDispose
    .family<AccountModels?, String?>((ref, username) async {
  return ref.read(AccountReqProvider).accountData(username);
});

class AccountReq {
//... Account data...//
  Future<AccountModels?> accountData(username) async {
    print("req usrname  : $username");

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    //... Url for my account and others account
    var url = username != null
        ? Uri.parse('${Const.BASE_URl}/account/$username')
        : Uri.parse('${Const.BASE_URl}/account/');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        return AccountModels.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
