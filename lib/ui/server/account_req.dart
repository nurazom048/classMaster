import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AccountReq {
  // String base = "http://192.168.0.125:3000";
  String base = "http://192.168.31.229:3000";

//
//... Account data
  Future<dynamic> accountData(username) async {
    print("req$username");
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse('$base/account/view_others/qq');
    var url_otherAc =
        Uri.parse('$base/account/view_others/${username.toString()}');

    final response = await http.post(username == null ? url : url_otherAc,
        headers: {'Authorization': 'Bearer $getToken'});

    if (response.statusCode == 200) {
      //.. responce
      final res = json.decode(response.body)["user"];
      print(response);
      return res;
    } else {
      throw Exception('Failed to load data');
    }
  }
}


//!.. Provider ...!//
