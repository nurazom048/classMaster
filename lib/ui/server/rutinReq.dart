// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/Alart.dart';
import 'package:table/models/ClsassDetailsModel.dart';

class Rutin_Req {
  //
  //
  String base = "192.168.0.125:3000";
  //String base = "192.168.31.229:3000";

  //
  ///.......... For all Class and priodes........///
  Future<ClassDetailsModel?> rutins_class_and_priode(context, rutinId) async {
    var url = Uri.parse('http://$base/class/$rutinId/all/class');
    try {
      //.. 1 request ...//
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);

        //
        var classDetalis = ClassDetailsModel.fromJson(res);

        return classDetalis;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart().errorAlartDilog(context, e.toString());
    }
  }

//....  For chackStatus ......///

  Future chackStatus(rutinId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('http://$base/rutin/save/$rutinId/chack');

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        print("object");
        print(res["user"]);
        return res;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }
}
