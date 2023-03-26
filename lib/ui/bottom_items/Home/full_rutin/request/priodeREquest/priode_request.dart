import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/messageModel.dart';
import 'package:http/http.dart' as http;
import '../../../../../../helper/constant/constant.dart';

//... provider...//
final priodeRequestProvider = Provider<PriodeRequest>((ref) => PriodeRequest());

//

class PriodeRequest {
//... Delete  Priode request....//

  Future<Either<String, Message>> deletePriode(String priodeId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final url = Uri.parse('${Const.BASE_URl}/rutin/priode/remove/$priodeId');

    try {
      // request

      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);
      print(res);

      Message messsaeg = Message.fromJson(res);

      if (response.statusCode == 200) {
        return right(messsaeg);
      } else {
        throw Exception(res);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //
  //... add priode....//
  Future<Either<String, Message>> addPriode(
      DateTime startTime, DateTime endTime, String rutinId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/add/$rutinId');

    try {
      final response = await http.post(url, body: {
        "start_time": "${startTime.toIso8601String()}Z",
        "end_time": "${endTime.toIso8601String()}Z",
      }, headers: {
        'Authorization': 'Bearer $getToken'
      });

      var res = json.decode(response.body);
      print(res);
      Message message = Message.fromJson(res);

      if (response.statusCode == 200) {
        return right(message);
      } else {
        return left(message.message);
      }
    } catch (e) {
      print("s $e");
      return left(e.toString());
    }
  }
}
