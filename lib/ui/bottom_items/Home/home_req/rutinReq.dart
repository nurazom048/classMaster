// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';

//

class RutinReqest {
//******    Create Rutins    ********* */
  Future<Either<String, void>> creatRutin({rutinName}) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/rutin/create'),
        body: {"name": rutinName.text},
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        //print response
        // print("rutin created successfully");
        // print(res);
        return right(null);
      } else {
        return right(null);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //.. search rutin.....//
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
