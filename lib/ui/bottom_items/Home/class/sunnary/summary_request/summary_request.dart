import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import '../../../../../../models/summaryModels.dart';
import 'package:http/http.dart' as http;

class SummayReuest {
  Future<SummayModels> getSummaryList(classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/summary/${classId}');

    //... send request
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        var listOsSummary = SummayModels.fromJson(res);

        return listOsSummary;
      } else {
        return throw Exception("faild to load data");
        ;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
