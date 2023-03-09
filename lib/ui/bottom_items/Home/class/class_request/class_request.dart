import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/widgets/Alart.dart';

class ClassesRequest {
  //
  //,, delete class
  Future<void> deleteClass(context, classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.delete(
          Uri.parse('${Const.BASE_URl}/class/delete/$classId'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        var message = json.decode(response.body)["message"];
        Alart.handleError(context, message.toString());
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e);
    }
  }
}
