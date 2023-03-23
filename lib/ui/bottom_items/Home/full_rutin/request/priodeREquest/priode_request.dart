import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/widgets/Alart.dart';
import 'package:http/http.dart' as http;
import '../../../../../../helper/constant/constant.dart';

//... provider...//
final priodeRequestProvider = Provider<priodeRequest>((ref) => priodeRequest());

//
final deletePriodeProvider =
    FutureProvider.autoDispose.family<Message?, String>((ref, priodeId) async {
  return await ref.read(priodeRequestProvider).deletePriode(priodeId);
});

class priodeRequest {
//... Delete  Priode request....//

  Future<Message?> deletePriode(String priodeId) async {
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
        return messsaeg;
      } else {
        throw Exception(res);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
