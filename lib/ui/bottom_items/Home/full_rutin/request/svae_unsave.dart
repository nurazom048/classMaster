// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';
import '../../../../../models/messageModel.dart';

class p {
  final String r;
  final bool c;
  p({required this.r, required this.c});
}

final saveProvider =
    FutureProvider.family<Future<Either<String, Message>>, p>((ref, p) async {
  return ref.read(saveUnsaveProvider).saveUnsaveRutinReq(p.r, p.c);
});

final saveUnsaveProvider = Provider<saveUnsave>((ref) => saveUnsave());

class saveUnsave {
  Future<Either<String, Message>> saveUnsaveRutinReq(rutinId, consition) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      var url = Uri.parse('${Const.BASE_URl}/rutin/save_unsave/$rutinId');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"saveCondition": "$consition"},
      );

      final res = json.decode(response.body);
      Message m = Message.fromJson(res);
      print("from unsave :$res");
      if (response.statusCode == 200) {
        return right(m);
      } else {
        return right(m);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
