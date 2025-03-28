// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:classmate/features/routine_summary_fetures/presentation/socket%20services/socketCon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/export_core.dart';
import '../../../../core/local data/local_data.dart';
import '../../../routine_Fetures/data/models/check_status_model.dart';
import '../models/all_summary_models.dart';
import 'package:http/http.dart' as http;

//... Providers....//
final summaryReqProvider = Provider<SummaryRequest>((ref) => SummaryRequest());

// Summary request...//
class SummaryRequest {
  //
// add summary///
  static Future<Either<Message, Message>> addSummaryRequest({
    required String classId,
    required String routineId,
    required String message,
    required List<XFile> imageLinks, // Changed to XFile
    required bool checkedType,
  }) async {
    final Map<String, String> headers = await LocalData.getHeader();
    final uri = Uri.parse('${Const.BASE_URl}/summary/add/$classId');

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      request.fields['message'] = message;
      request.fields['checkedType'] = checkedType.toString();

      // Add images based on platform
      for (var image in imageLinks) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'imageLinks',
            bytes,
            filename: image.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'imageLinks',
            image.path,
          ));
        }
      }

      // Socket notification
      SocketService.sendMessage(room: routineId);

      var streamedResponse = await request.send();
      var rs = await http.Response.fromStream(streamedResponse);
      final result = jsonDecode(rs.body) as Map<String, dynamic>;

      if (streamedResponse.statusCode == 201) {
        return right(Message(message: result["message"].toString()));
      } else {
        return right(Message(message: result["message"].toString()));
      }
    } catch (error) {
      return left(Message(message: error.toString()));
    }
  }

//***************************************************************************************/
//--------------------------- -get summary --------------------------------------/
//**************************************************************************************/

  Future<AllSummaryModel> getSummaryList(String? classId, {int? pages}) async {
    print("call get summary ");
    String queryPage = pages != null ? "?page=$pages" : '';
    String findClassId = classId ?? '';

    final Map<String, String> headers = await LocalData.getHeader();

    var url = Uri.parse('${Const.BASE_URl}/summary/$findClassId' + queryPage);

    //... send request....//
    try {
      final response = await http.get(url, headers: headers);
      var res = json.decode(response.body);
      // print(url);
      // print(res);

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        var listOsSummary = AllSummaryModel.fromJson(res);

        return listOsSummary;
      } else {
        return Future.error("failed to load data");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// get summary........///

  static Future<Either<Message, Message>> deleteSummary(
      String summaryID) async {
    final Map<String, String> headers = await LocalData.getHeader();

    var url = Uri.parse('${Const.BASE_URl}/summary/$summaryID');

    print(url);

    //... send request....//
    try {
      final response = await http.delete(
        url,
        headers: headers,
      );
      var res = json.decode(response.body);
      var message = Message.fromJson(res);
      print(res);

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        return right(message);
      } else {
        return left(message);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //**************** SUMMARY STATUS**************** */
  //....CheckStatusModel....//
  Future<CheckStatusModel> checkStatus(summaryID) async {
    final Map<String, String> headers = await LocalData.getHeader();

    final Uri url = Uri.parse('${Const.BASE_URl}/summary/status/$summaryID');
    // final bool isOnline = await Utils.isOnlineMethod();
    // var isHaveCash = awaitMyApiCache.haveCache("checkStatus$summaryID");

    try {
      // // if offline and have cash
      // if (isOnline == false && isHaveCash) {
      //   final getdata = await MyApiCash.getData("checkStatus$summaryID");
      //   return CheckStatusModel.fromJson(getdata);
      // }

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

//saved cash
        // // save to csh
        // APICacheDBModel cacheDBModel = APICacheDBModel(
        //     key: "checkStatus$rutin_id", syncData: response.body);

        //

        //
        CheckStatusModel res =
            CheckStatusModel.fromJson(jsonDecode(response.body));
        print("res  ${jsonDecode(response.body)}");
        return res;
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      print(e);
      throw Future.error(e);
    }
  }

  //******* Save unsaved summary ********* */

  Future<Either<Message, Message>> saveSummary(
      String summaryId, bool save) async {
    final Map<String, String> headers = await LocalData.getHeader();

    final url = Uri.parse('${Const.BASE_URl}/summary/save');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {"summaryId": summaryId, "save": save.toString()},
      );
      var res = json.decode(response.body);
      print(res);

      Message message = Message.fromJson(res);

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        return right(message);
      } else {
        throw Exception(message.message);
      }
    } catch (error) {
      print(error);
      return left(Message(message: error.toString()));
    }
  }
}
