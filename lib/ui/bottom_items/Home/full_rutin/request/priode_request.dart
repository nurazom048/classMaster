import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/messageModel.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/priode/all_priode_models.dart';
import '../../../../../helper/constant/constant.dart';

//... provider...//
final priodeRequestProvider = Provider<PriodeRequest>((ref) => PriodeRequest());

//
final allPriodeProvider =
    FutureProvider.family<Either<Message, AllPriodeList>, String>(
        (ref, rutinId) async {
  return ref.read(priodeRequestProvider).allPriode(rutinId);
});

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
      print(e);
      return left(e.toString());
    }
  }

  //
  //... add priode....//
  Future<Either<String, Message>> addPriode(
      Map<String, dynamic> priodeItm, String rutinId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/add/$rutinId');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
          "start_time": "${priodeItm["start_time"].toIso8601String()}Z",
          "end_time": "${priodeItm["end_time"].toIso8601String()}Z",
          "priode_number": priodeItm["priode_number"]?.toString() ?? "0"
        },
      );

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

  ///
  ///
  ///
  Future<Either<Message, AllPriodeList>> allPriode(String rutinId) async {
    var url = Uri.parse('${Const.BASE_URl}/rutin/all_priode/$rutinId');

    try {
      final response = await http.get(url);

      var res = json.decode(response.body);
      print(res);
      Message message = Message.fromJson(res);
      AllPriodeList allPriode = AllPriodeList.fromJson(res);

      if (response.statusCode == 200) {
        return right(allPriode);
      } else {
        return left(message);
      }
    } catch (e) {
      print("s $e");
      return left(Message(message: e.toString()));
    }
  }
}
