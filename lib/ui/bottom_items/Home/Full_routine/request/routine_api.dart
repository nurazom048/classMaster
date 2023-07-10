// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable, camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/class_details_model.dart';

import '../../../../../constant/constant.dart';
import '../../../../../local data/api_cashe_maager.dart';
import '../../utils/utils.dart';

final routine_Req_provider = Provider<Routine_Req>((ref) => Routine_Req());

//.... routine_details_provider
final routine_details_provider = FutureProvider.autoDispose
    .family<NewClassDetailsModel?, String>((ref, routineId) async {
  return ref.read(routine_Req_provider).routine_class_and_priode(routineId);
});

class Routine_Req {
  //

  Future<NewClassDetailsModel?> routine_class_and_priode(
      String routineId) async {
    print('*****************************************');

    print(routineId);

    final bool isOnline = await Utils.isOnlineMethod();
    final String path = "${Const.BASE_URl}/class/$routineId/all/class";
    final url = Uri.parse(path);
    final String key = "Class-$path";
    final isHaveCache = await MyApiCash.haveCash(key);

    try {
      // If offline and have cache
      if (!isOnline && isHaveCache) {
        final getData = await MyApiCash.getData(key);
        return NewClassDetailsModel.fromJson(getData);
      } else {
        final response = await http.get(url);
        final res = json.decode(response.body);
        print(res);
        if (response.statusCode == 200) {
          // Save to cache manager
          MyApiCash.saveLocal(key: key, syncData: response.body);

          final classDetails = NewClassDetailsModel.fromJson(res);
          return classDetails;
        } else {
          throw "error ${res['message']}";
        }
      }
    } catch (error) {
      if (isHaveCache) {
        final getData = await MyApiCash.getData(key);
        return NewClassDetailsModel.fromJson(getData);
      }
      rethrow;
    }
  }
}
