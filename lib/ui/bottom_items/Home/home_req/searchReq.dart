// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:table/helper/constant/constant.dart';
import 'package:http/http.dart' as http;

class SearchRequest {
  Future<void> searchRoutine(String valu) async {
    print(valu);
    try {
      final response =
          await http.post(Uri.parse('${Const.BASE_URl}/rutin/search/$valu'));

      if (response.statusCode == 200) {
        var seach_result = json.decode(response.body)["rutins"];

        //  print(seach_result);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
