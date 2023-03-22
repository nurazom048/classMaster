// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';
import '../../../../../models/messageModel.dart';

//.. provider...//
final saveReqProvider =
    Provider<SaveUnsaveRequest>((ref) => SaveUnsaveRequest());

//.... Request......//
class SaveUnsaveRequest {
  //... for save and unsave .. togole ...///
  Future<Either<String, Message>> saveUnsaveRutinReq(rutinId, condition) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/save_unsave/$rutinId');
    final headers = {'Authorization': 'Bearer $getToken'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {'saveCondition': '$condition'},
      );

      final res = json.decode(response.body);
      final message = Message.fromJson(res);
      print('from unsave: $res');

      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
