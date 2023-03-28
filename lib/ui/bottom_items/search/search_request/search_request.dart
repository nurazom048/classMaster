// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:http/http.dart' as http;
import '../../../../models/rutins/search_rutin.dart';
import '../../../../models/search_account.dart';

//.. Provider...//
final searchRequestProvider = Provider.autoDispose((ref) => SearchRequest());

//
final searchRoutineProvider =
    FutureProvider.family<RutinQuarry?, String>((ref, valu) async {
  return ref.read(searchRequestProvider).searchRoutine(valu);
});

final search_Account_Provider = FutureProvider.autoDispose
    .family<AccountsResponse, String>((ref, valu) async {
  return ref.read(searchRequestProvider).searchAccount(valu);
});

//
//
//...... SearchRequest.....//
class SearchRequest {
//.... Rutin Search .....///
  Future<RutinQuarry?> searchRoutine(String? valu) async {
    print("valu pici vai : $valu");
    var url = Uri.parse('${Const.BASE_URl}/rutin/search?src=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);
      // print(res);

      if (response.statusCode == 200) {
        return RutinQuarry.fromJson(res);
      } else {
        throw Exception("fild to get rutin");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("fild to get rutin");
    }
  }

  //********* searchAccount   ************ *//

  Future<AccountsResponse> searchAccount(String valu) async {
    print("valu pici vai : $valu");
    var url = Uri.parse('${Const.BASE_URl}/account/find?q=$valu');

    try {
      final response = await http.get(url);
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        //   print(json.decode(response.body));
        return AccountsResponse.fromJson(res);
      } else {
        throw Exception("faild");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
