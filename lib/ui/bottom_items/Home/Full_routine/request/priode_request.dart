// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/local%20data/local_data.dart';
import 'package:table/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/priode/all_priode_models.dart';

import '../../../../../constant/constant.dart';
import '../../../../../local data/api_cashe_maager.dart';
import '../../../Add/screens/add_priode.dart';
import '../../utils/utils.dart';

//... provider...//
final priodeRequestProvider = Provider<PriodeRequest>((ref) => PriodeRequest());

class PriodeRequest {
//... Delete  Priode request....//

  Future<Either<String, Message>> deletePriode(String priodeId) async {
    final headers = await LocalData.getHerder();
    final url = Uri.parse('${Const.BASE_URl}/rutin/priode/remove/$priodeId');

    try {
      // request

      final response = await http.delete(
        url,
        headers: headers,
      );
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        Message message = Message.fromJson(res);

        return right(message);
      } else {
        Message message = Message.fromJson(res);

        return left(message.message);
      }
    } catch (e) {
      print(e);
      return left(e.toString());
    }
  }

  //
  //... add priode....//
  Future<Either<String, Message>> addPriode(
    String routineID,
    DateTime startTime,
    DateTime endTime,
  ) async {
    // Obtain shared preferences.
    final headers = await LocalData.getHerder();
    final url = Uri.parse('${Const.BASE_URl}/rutin/priode/add/$routineID');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "start_time": "${startTime.toIso8601String()}Z",
          "end_time": "${endTime.toIso8601String()}Z",
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
  /// GET : All Priode In Routine
  Future<AllPriodeList> allPriode(String routineID) async {
    final url = Uri.parse('${Const.BASE_URl}/rutin/all_priode/$routineID');

    final bool isOnline = await Utils.isOnlineMethod();
    final String key = "Priodes-$url";
    final bool isHaveCache = await MyApiCash.haveCash(key);

    try {
      // print('$isOnline $isHaveCache');
      if (!isOnline && isHaveCache) {
        final getdata = await MyApiCash.getData(key);

        return AllPriodeList.fromJson(getdata);
      }
      //
      final response = await http.get(url);
      final res = json.decode(response.body);
      print(res);
      final message = Message.fromJson(res);
      final allPriode = AllPriodeList.fromJson(res);

      if (response.statusCode == 200) {
        // When success, save data into cache
        MyApiCash.saveLocal(key: key, syncData: response.body);

        // Return the response
        return allPriode;
      } else {
        throw message;
      }
    } on SocketException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<Either<Message, AllPriode>> findPriodesYid(String priodeId) async {
    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/find/$priodeId');

    try {
      final response = await http.get(url);

      var res = json.decode(response.body);

      AllPriode priode = AllPriode.fromJson(res);

      if (response.statusCode == 200) {
        return right(priode);
      } else {
        return right(priode);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //... add priode....//
  Future<Either<String, Message>> edditPriode(
    String priodeId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final headers = await LocalData.getHerder();

    var url = Uri.parse('${Const.BASE_URl}/rutin/priode/eddit/$priodeId');

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: {
          "start_time": endMaker(startTime.toIso8601String().toString()),
          "end_time": endMaker(endTime.toIso8601String().toString()),
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
}
