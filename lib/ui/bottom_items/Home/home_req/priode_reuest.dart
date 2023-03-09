import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/widgets/Alart.dart';

class PriodeRequest {
//... Delete Request ...//
  Future<void> deletePriode(context, priodeId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/priode/remove/$priodeId');

    try {
      // request

      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        Alart.showSnackBar(context, res["message"]);
      } else {
        Alart.showSnackBar(context, res["message"]);
      }
    } catch (e) {
      Alart.handleError(context, e);
    }
  }
}
