// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import '../../../../../../constant/constant.dart';
import '../../../../../../models/check_status_model.dart';
import '../models/all_summary_models.dart';
import 'package:http/http.dart' as http;

//... Providers....//
final summaryReqProvider = Provider<SummaryRequest>((ref) => SummaryRequest());

// Summary request...//
class SummaryRequest {
  //
// add summary///
  static Future<Either<Message, Message>> addSummaryRequest(
      String classId, String message, List<String> imageLinks) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final uri = Uri.parse('${Const.BASE_URl}/summary/add/$classId');

    try {
      var request = http.MultipartRequest('POST', uri);

      // Add the authorization header
      request.headers.addAll({'Authorization': 'Bearer $getToken'});

      // Add the message field
      request.fields['message'] = message;

      // Convert the image links to multipart files and add to the request
      for (int i = 0; i < imageLinks.length; i++) {
        MultipartFile file =
            await http.MultipartFile.fromPath('imageLinks', imageLinks[i]);
        request.files.add(file);
      }

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

  /// get summary........///

  Future<AllSummaryModel> getSummaryList(String? classId, {int? pages}) async {
    print("call get summary ");
    String queryPage = pages != null ? "?page=$pages" : '';
    String findClassId = classId ?? '';

    final String? getToken = await AuthController.getToken();

    var url = Uri.parse('${Const.BASE_URl}/summary/$findClassId' + queryPage);
    Map<String, String> headers = {'Authorization': 'Bearer $getToken'};
    //... send request....//
    try {
      final response = await http.get(url, headers: headers);
      var res = json.decode(response.body);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(url);
      print(res);

      if (response.statusCode == 200) {
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
    final String? getToken = await AuthController.getToken();
    var url = Uri.parse('${Const.BASE_URl}/summary/$summaryID');

    print(url);

    //... send request....//
    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      var res = json.decode(response.body);
      var message = Message.fromJson(res);
      print(res);

      if (response.statusCode == 200) {
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
    final String? getToken = await AuthController.getToken();
    final Uri url = Uri.parse('${Const.BASE_URl}/summary/status/$summaryID');
    final Map<String, String> headers = {'Authorization': 'Bearer $getToken'};
    // final bool isOnline = await Utils.isOnlineMethod();
    // var isHaveCash =
    // await APICacheManager().isAPICacheKeyExist("checkStatus$summaryID");

    try {
      // if offline and have cash
      // if (isOnline == false && isHaveCash) {
      //   var getdata =
      //       await APICacheManager().getCacheData("checkStatus$rutin_id");
      //   print('From cash $getdata');
      //   return CheckStatusModel.fromJson(jsonDecode(getdata.syncData));
      // }

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
//saved cash
        // // save to csh
        // APICacheDBModel cacheDBModel = APICacheDBModel(
        //     key: "checkStatus$rutin_id", syncData: response.body);

        // await APICacheManager().addCacheData(cacheDBModel);

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
      return Future.error(e);
    }
  }

  //******* Save unsaved summary ********* */

  Future<Either<Message, Message>> saveSummary(
      String summaryId, bool save) async {
    final token = await AuthController.getToken();

    final url = Uri.parse('${Const.BASE_URl}/summary/save');
    final headers = {'Authorization': 'Bearer $token'};

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
