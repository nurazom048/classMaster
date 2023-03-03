// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/ClsassDetailsModel.dart';

final Rutin_Req_provider = Provider<Rutin_Req>((ref) => Rutin_Req());

//.... Rutins DEtals Provider
final rutins_detalis_provider =
    FutureProvider.family<ClassDetailsModel?, String>((ref, rutinId) async {
  return ref.read(Rutin_Req_provider).rutins_class_and_priode(rutinId);
});

class Rutin_Req {
  //
  //
  // String base = "192.168.0.125:3000";
  String base = "192.168.31.229:3000";

  //

  ///.......... For all Class and priodes........///
  Future<ClassDetailsModel?> rutins_class_and_priode(String rutinId) async {
    // var url = Uri.parse('http://$base/class/$rutinId/all/class');
    var url = Uri.parse("http://192.168.31.229:3000/class/$rutinId/all/class");

    try {
      //.. 1 request ...//
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        print(res["finalCap10List"]);

        var classDetalis = ClassDetailsModel.fromJson(res);

        return classDetalis;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e.toString());

      return null;
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

//!.. Provider ...!//

final Rutin_ReqProvider = Provider<Rutin_Req>((ref) => Rutin_Req());

//
