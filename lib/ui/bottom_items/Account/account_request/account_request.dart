// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

class AccountReq {
//... Account data...//
  Future<dynamic> accountData(username, myAccount) async {
    print("req : $username , myac :$myAccount");

    //

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    //... Url for my account and others account

    var url = Uri.parse('${Const.BASE_URl}/account/view_others/qq');
    var url_otherAc =
        Uri.parse('${Const.BASE_URl}/account/view_others/$username');

    final response = await http.post(myAccount == true ? url : url_otherAc,
        headers: {'Authorization': 'Bearer $getToken'});

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body)["user"];
      print(response.body);
      return res;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
