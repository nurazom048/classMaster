// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

class AccountReq {
//... Account data...//
  Future<dynamic> accountData(username) async {
    print("req : $username ");

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    //... Url for my account and others account

    var url = Uri.parse('${Const.BASE_URl}/account/$username');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body)["user"];

      if (response.statusCode == 200) {
        print(response.body);
        return res;
      } else {
        print(response.body);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
