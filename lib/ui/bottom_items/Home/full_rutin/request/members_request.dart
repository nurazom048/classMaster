// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, body_might_complete_normally_nullable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/membersModels.dart';

class membersRequest {
//**********************   rutin all _members    *********** */
  Future<MembersModel?> all_members(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (response.body != null) {
          var res = jsonDecode(response.body);
          print(res);
          return MembersModel.fromJson(res);
        } else {
          throw Exception("faild to load all member list ");
        }
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
