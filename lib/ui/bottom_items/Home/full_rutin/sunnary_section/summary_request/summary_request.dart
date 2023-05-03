import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/messageModel.dart';
import '../models/all_summary_models.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

//... Providers....//
final summaryReqProvider = Provider<SummayReuest>((ref) => SummayReuest());

// Summarys request...//
class SummayReuest {
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

  Future<AllSummaryModel> getSummaryList(classId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/summary/$classId');

    //... send request....//
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $getToken'});
      var res = json.decode(response.body);

      if (response.statusCode == 200) {
        var listOsSummary = AllSummaryModel.fromJson(res);

        return listOsSummary;
      } else {
        return Future.error("faild to load data");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
