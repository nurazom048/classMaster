// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/class_details_model.dart';

import '../../constant/constant.dart';

final Rutin_Req_provider = Provider<Rutin_Req>((ref) => Rutin_Req());

//.... Rutins DEtals Provider
final rutins_detalis_provider = FutureProvider.autoDispose
    .family<NewClassDetailsModel?, String>((ref, rutinId) async {
  return ref.read(Rutin_Req_provider).rutins_class_and_priode(rutinId);
});

class Rutin_Req {
  //

  ///.......... For all Class and priodes........///
  Future<NewClassDetailsModel?> rutins_class_and_priode(String rutinId) async {
    print(rutinId);
    var url = Uri.parse("${Const.BASE_URl}/class/$rutinId/all/class");

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);
      //  print(res);
      if (response.statusCode == 200) {
        var classDetalis = NewClassDetailsModel.fromJson(res);

        return classDetalis;
      }
    } catch (e) {
      print(e.toString());
      return throw Future.error(e);
    }
  }
}
