// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:http/http.dart' as http;

//.. Provider...//
final searchRoutineProvider =
    FutureProvider.family<dynamic, String>((ref, valu) async {
  return ref.read(searchRequestProvider).searchRoutine(valu);
});

final search_Account_Provider =
    FutureProvider.family<dynamic, String>((ref, valu) async {
  return ref.read(searchRequestProvider).searchAccount(valu);
});

class SearchRequest {
//.... Rutin Search .....///
  Future searchRoutine(String valu) async {
    print("valu pici vai : $valu");
    var url = Uri.parse('${Const.BASE_URl}/rutin/search/$valu');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //   print(json.decode(response.body));
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //*********    ************ *//

  Future searchAccount(String valu) async {
    print("valu pici vai : $valu");
    var url =
        Uri.parse('${Const.BASE_URl}/account/find/account?username=$valu');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        //   print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final searchRequestProvider = Provider((ref) => SearchRequest());
