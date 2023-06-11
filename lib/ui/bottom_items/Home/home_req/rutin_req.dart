// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import '../../../../constant/constant.dart';
import '../../../../models/rutins/list_of_save_rutin.dart';

//_________________________

//uploadedRutinsControllerProvider
final uploadedRutinsControllerProvider = FutureProvider.autoDispose
    .family<ListOfUploadedRutins, String?>((ref, username) {
  return ref.read(home_req_provider).uplodedRutins(username: username);
});

class RutinReqest {
//******    Create Rutins    ********* */
  static Future<Either<Message, Message>> creatRutin({rutinName}) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/rutin/create'),
        body: {"name": rutinName.toString()},
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      final res = json.decode(response.body);
      Message message = Message.fromJson(res);

      //
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print(res);
        return right(message);
      } else {
        return left(message);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
