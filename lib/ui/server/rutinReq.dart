// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/ClsassDetailsModel.dart';

final Rutin_Req_provider = Provider<Rutin_Req>((ref) => Rutin_Req());

//.... Rutins DEtals Provider
final rutins_detalis_provider = FutureProvider.autoDispose
    .family<ClassDetailsModel?, String>((ref, rutinId) async {
  return ref.read(Rutin_Req_provider).rutins_class_and_priode(rutinId);
});

class Rutin_Req {
  //

  ///.......... For all Class and priodes........///
  Future<ClassDetailsModel?> rutins_class_and_priode(String rutinId) async {
    var url = Uri.parse("${Const.BASE_URl}/class/$rutinId/all/class");

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      //.. 1 request ...//
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

      // print("rutins_class_and_priode" + response.body);

      if (response.statusCode == 200) {
        var res = json.decode(response.body);

        var classDetalis = ClassDetailsModel.fromJson(res);

        return classDetalis;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//... unsave rutine ....//
  Future unSaveRutin(rutinId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      final response = await http.get(
          Uri.parse('${Const.BASE_URl}/rutin/unsave/$rutinId'),
          headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        print(res);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  //

  // Future chackStatus() async {
  //   // Obtain shared preferences.
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');
  //   try {
  //     final response = await http.get(
  //         Uri.parse('${Const.BASE_URl}/rutin/save/:$rutinId/chack'),
  //         headers: {'Authorization': 'Bearer $getToken'});

  //     if (response.statusCode == 200) {
  //       final res = json.decode(response.body);

  //       //  print(res);
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}

//!.. Provider ...!//

final Rutin_ReqProvider = Provider<Rutin_Req>((ref) => Rutin_Req());

//
