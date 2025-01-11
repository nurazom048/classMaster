// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/socket%20services/socketCon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:classmate/models/message_model.dart';
import '../../../../../../constant/constant.dart';
import '../../../../../../local data/local_data.dart';
import '../../../../../../models/check_status_model.dart';
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
    required List<String> imageLinks,
    required bool checkedType,
  }) async {
    final Map<String, String> headers = await LocalData.getHerder();

    final uri = Uri.parse('${Const.BASE_URl}/summary/add/$classId');

    try {
      var request = http.MultipartRequest('POST', uri);

      // Add the authorization header
      request.headers.addAll(headers);

      // Add the message field
      request.fields['message'] = message;
      request.fields['checkedType'] = checkedType.toString();

      // Convert the image links to multipart files and add to the request
      for (int i = 0; i < imageLinks.length; i++) {
        MultipartFile file =
            await http.MultipartFile.fromPath('imageLinks', imageLinks[i]);
        request.files.add(file);
      }
// socket to this room

      SocketService.sendMessage(room: routineId);

      // Send the request and wait for the response

      var streamedResponse = await request.send();

      var rs = await http.Response.fromStream(streamedResponse);
      final result = jsonDecode(rs.body) as Map<String, dynamic>;

      if (streamedResponse.statusCode == 201) {
        // print('Summary created successfully');
        return right(Message(message: result["message"].toString()));
      } else {
        // print('Error creating summary: ${response.reasonPhrase}');
        return right(Message(message: result["message"].toString()));
      }
    } catch (error) {
      //print('Error creating summary: $error');
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

    final Map<String, String> headers = await LocalData.getHerder();

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
    final Map<String, String> headers = await LocalData.getHerder();

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
    final Map<String, String> headers = await LocalData.getHerder();

    final Uri url = Uri.parse('${Const.BASE_URl}/summary/status/$summaryID');
    // final bool isOnline = await Utils.isOnlineMethod();
    // var isHaveCash = await MyApiCash.haveCash("checkStatus$summaryID");

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
    final Map<String, String> headers = await LocalData.getHerder();

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
