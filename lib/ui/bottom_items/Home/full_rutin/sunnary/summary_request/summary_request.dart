import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/messageModel.dart';
import '../../../../../../models/summaryModels.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
//... Providers....//

final summaryReqProvider = Provider<SummayReuest>((ref) => SummayReuest());

final getSumarisProvider = FutureProvider.autoDispose
    .family<SummayModels, String>((ref, classId) async {
  return ref.read(summaryReqProvider).getSummaryList(classId);
});

//

// Summarys request...//
class SummayReuest {
  //
// add summary///

  static Future<Either<Message, Message>> addSummaryRequest(
      String message, List<String> imageLinks) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final uri =
        Uri.parse('${Const.BASE_URl}/summary/add/644f8bc80f3ee6456717f61e');

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
      print("response");

      var rs = await http.Response.fromStream(streamedResponse);
      final result = jsonDecode(rs.body) as Map<String, dynamic>;
      print(result);

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

  Future<SummayModels> getSummaryList(classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/summary/$classId');

    //... send request
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $getToken'});

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        var listOsSummary = SummayModels.fromJson(res);

        return listOsSummary;
      } else {
        return throw Exception("faild to load data");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
