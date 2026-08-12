import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../implements/member_imp.dart';
import '../models/members_models.dart';
import '../models/see_all_request_model.dart';

final routineMemberReqProvider = Provider<MemberRepositoryImp>(
  (ref) => RoutineMemberRequestImpl(),
);

class RoutineMemberRequestImpl implements MemberRepositoryImp {
  // Step 4: Rewrote RoutineMemberRequestImpl to match the MemberRepositoryImp interface and consume standard RESTful endpoints with correct HTTP verbs.
  @override
  Future<RoutineMembersModel?> getAllMembers(
    String routineID, {
    int page = 1,
    int limit = 10,
  }) async {
    final header = await LocalData.getHeader();
    // 🆕 Updated to GET and uses new route structure
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/$routineID/members?page=$page&limit=$limit',
    );

    try {
      final response = await http.get(url, headers: header);
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return RoutineMembersModel.fromJson(res);
      } else {
        throw Exception(res['message'] ?? "Failed to load all member list");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<String, Message>> sendMemberRequest(
    String routineID, {
    String? targetAccountId,
    String? requestMessage,
  }) async {
    final header = await LocalData.getHeader();
    final Uri url = Uri.parse('${Const.BASE_URl}/routine/$routineID/members');

    try {
      final response = await http.post(
        url,
        headers: header,
        body: jsonEncode({
          if (targetAccountId != null) "targetAccountId": targetAccountId,
          if (requestMessage != null) "requestMessage": requestMessage,
        }),
      );

      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return right(Message.fromJson(res));
      } else {
        return left(res['message'] ?? "Failed to send request");
      }
    } on io.SocketException catch (_) {
      return left('Network error. Failed to send request');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Message> updateMemberRole(
    String routineID,
    String accountId, {
    bool? isCaptain,
    bool? notificationOn,
  }) async {
    final header = await LocalData.getHeader();
    // 🆕 Using PATCH for updates
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/$routineID/members/$accountId',
    );

    try {
      final response = await http.patch(
        url,
        headers: header,
        body: jsonEncode({
          if (isCaptain != null) "isCaptain": isCaptain,
          if (notificationOn != null) "notificationOn": notificationOn,
        }),
      );

      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Message.fromJson(res);
      } else {
        throw Exception(res['message'] ?? "Failed to update member");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Either<Message, Message>> removeMember(
    String routineID,
    String accountId,
  ) async {
    final header = await LocalData.getHeader();
    // 🆕 Single DELETE route handles Kick, Leave, and Remove
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/$routineID/members/$accountId',
    );

    try {
      final response = await http.delete(url, headers: header);
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return right(Message.fromJson(res));
      } else {
        return left(Message.fromJson(res));
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  @override
  Future<SeeAllRequestModel> getAllRequests(String routineID) async {
    final header = await LocalData.getHeader();
    // 🆕 Now uses GET request
    final Uri url = Uri.parse('${Const.BASE_URl}/routine/$routineID/requests');

    try {
      final response = await http.get(url, headers: header);
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SeeAllRequestModel.fromJson(res);
      } else {
        throw Exception(res['message'] ?? "Failed to load requests");
      }
    } on io.SocketException catch (_) {
      throw Exception('Network error. Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Message> handleRequestStatus(
    String routineID, {
    String? requestId,
    String? status,
    bool? acceptAll,
  }) async {
    final header = await LocalData.getHeader();

    // If 'acceptAll' is true, requestId might be empty or null, so we provide a safe fallback string for the URL
    final safeRequestId = (requestId == null || requestId.isEmpty) ? 'bulk' : requestId;
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/$routineID/requests/$safeRequestId',
    );

    try {
      final response = await http.patch(
        url,
        headers: header,
        body: jsonEncode({
          if (status != null) "status": status,
          if (acceptAll != null) "acceptAll": acceptAll,
        }),
      );

      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Message.fromJson(res);
      } else {
        throw Exception(res['message'] ?? "Failed to handle request");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
