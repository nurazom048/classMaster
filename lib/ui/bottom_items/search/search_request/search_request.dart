// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';
import '../../../../constant/constant.dart';
import '../../../../models/rutins/search_rutin.dart';
import '../../../../models/search_account.dart';

//.. Provider...//
final searchRequestProvider = Provider.autoDispose((ref) => SearchRequest());

//
final searchRoutineProvider =
    FutureProvider.family<Either<Message, RutinQuarry?>, String>(
        (ref, valu) async {
  return ref.read(searchRequestProvider).searchRoutine(valu);
});

final search_Account_Provider = FutureProvider.autoDispose
    .family<Either<Message, AccountsResponse>, String>((ref, valu) async {
  return ref.read(searchRequestProvider).searchAccount(valu);
});

//
//
//...... SearchRequest.....//
class SearchRequest {
//.... Rutin Search .....///
  Future<Either<Message, RutinQuarry?>> searchRoutine(String? valu) async {
    print("valu pici vai : $valu");
    //  var url = Uri.parse('${Const.BASE_URl}/rutin/search?src=$valu');
    var url = Uri.parse('${Const.BASE_URl}/rutin/search?src=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);
      print("print from body");
      print(res);
      if (response.statusCode == 200) {
        return right(RutinQuarry.fromJson(res));
      } else {
        throw Exception(res);
      }
    } catch (e) {
      print(e.toString());
      return left(Message(message: e.toString()));
    }
  }

  //********* searchAccount   ************ *//

  Future<Either<Message, AccountsResponse>> searchAccount(String valu) async {
    print("valu pici vai : $valu");
    var url = Uri.parse('${Const.BASE_URl}/account/find?q=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        //   print(json.decode(response.body));
        return right(AccountsResponse.fromJson(res));
      } else {
        throw Exception(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
