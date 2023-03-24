import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/messageModel.dart';
import '../../../../../../models/summaryModels.dart';
import 'package:http/http.dart' as http;

//... Providers....//

final summaryReqProvider = Provider<SummayReuest>((ref) => SummayReuest());

final getSumarisProvider = FutureProvider.autoDispose
    .family<SummayModels, String>((ref, classId) async {
  return ref.read(summaryReqProvider).getSummaryList(classId);
});

//

// Summarys request...//
class SummayReuest {
  //
// add summary///
  Future<Summary> addSummary(String classId, String summatText) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/summary/add/$classId'),
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"text": summatText},
      );
      var res = jsonDecode(response.body)["summary"];

      Summary s = Summary.fromJson(res);
      if (response.statusCode == 200) {
        return s;
      } else {
        throw Exception("hoi ni vai ");
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /// get summary........///

  Future<SummayModels> getSummaryList(classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/summary/$classId');

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
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
