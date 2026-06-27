// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:classmate/features/notice_fetures/domain/repositories/noticeboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:classmate/core/local_data/local_data.dart';
import '../../../../core/export_core.dart';
import '../../../routine/data/models/check_status_model.dart';

final noticeboardRequestProvider = Provider<NoticeboardRequest>(
  (ref) => NoticeboardRequest(),
);

// ============================================================================
// 2. NOTICEBOARD REQUESTS (Membership & Status)
// ============================================================================
class NoticeboardRequest implements NoticeboardRepository {
  //****** Leave Member ********* */
  @override
  Future<Either<Message, Message>> leaveMember(String academyID) async {
    // Step 1: Get headers and set DELETE URL (Updated)
    final headers = await LocalData.getHeader();
    var url = Uri.parse('${Const.BASE_URl}/notice/academy/$academyID/member');

    try {
      // Step 2: Send DELETE request to leave noticeboard
      final response = await http.delete(url, headers: headers);
      var res = Message.fromJson(jsonDecode(response.body));

      // Step 3: Handle response
      if (response.statusCode == 200) {
        return right(res);
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //****** Check Status ********* */
  @override
  Future<CheckStatusModel> checkStatus(String academyID) async {
    // Step 1: Get headers and set GET URL (Updated from POST to GET)
    final headers = await LocalData.getHeader();
    var url = Uri.parse('${Const.BASE_URl}/notice/academy/$academyID/status');

    try {
      // Step 2: Send GET request to fetch membership status
      final response = await http.get(url, headers: headers); // Changed to GET
      print("res  ${jsonDecode(response.body)}");

      // Step 3: Decode JSON to CheckStatusModel
      if (response.statusCode == 200) {
        CheckStatusModel res = CheckStatusModel.fromJson(
          jsonDecode(response.body),
        );
        return res;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //****** Send Join Request ********* */
  @override
  Future<Either<String, Message>> sendRequest(String academyID) async {
    // Step 1: Get headers and set POST URL (Updated)
    final headers = await LocalData.getHeader();
    var url = Uri.parse("${Const.BASE_URl}/notice/academy/$academyID/member");

    try {
      // Step 2: Send POST request to join noticeboard
      final response = await http.post(url, headers: headers);
      var res = Message.fromJson(jsonDecode(response.body));
      print("req from sendRequest $res");

      // Step 3: Handle response
      if (response.statusCode == 200) {
        return right(res);
      } else {
        return right(
          res,
        ); // Still right in original logic, you might want to change to left if it's an error
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //****** Notification Off ********* */
  @override
  Future<Either<String, Message>> notificationOff(String academyID) async {
    // Step 1: Get headers, ensure content-type is JSON
    final headers = await LocalData.getHeader();
    headers['Content-Type'] = 'application/json';

    // Step 2: Set PUT URL for turning notification off
    Uri url = Uri.parse(
      '${Const.BASE_URl}/notice/academy/$academyID/notification',
    );

    try {
      // Step 3: Send PUT request with JSON body { notificationOn: false }
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({"notificationOn": false}), // Added body
      );
      Message message = Message.fromJson(jsonDecode(response.body));

      // Step 4: Handle response
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //****** Notification On ********* */
  @override
  Future<Either<String, Message>> notificationOn(String academyID) async {
    // Step 1: Get headers, ensure content-type is JSON
    final headers = await LocalData.getHeader();
    headers['Content-Type'] = 'application/json';
    print('RoutineNotification $academyID');

    // Step 2: Set PUT URL for turning notification on
    Uri url = Uri.parse(
      '${Const.BASE_URl}/notice/academy/$academyID/notification',
    );

    try {
      // Step 3: Send PUT request with JSON body { notificationOn: true }
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({"notificationOn": true}), // Added body
      );
      Message message = Message.fromJson(jsonDecode(response.body));

      // Step 4: Handle response
      if (response.statusCode == 200) {
        return right(message);
      } else {
        return right(message);
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
