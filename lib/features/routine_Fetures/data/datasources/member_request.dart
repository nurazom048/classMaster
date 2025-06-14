// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable
import 'dart:async';
import 'dart:io' as io;

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:classmate/features/routine_Fetures/data/models/members_models.dart';
import '../../../../../core/local data/local_data.dart';
import '../../../../core/export_core.dart';
import '../models/see_all_request_model.dart';

final memberRequestProvider = Provider((ref) => MemberRequest());
final allMembersProvider = FutureProvider.family<RoutineMembersModel, String>((
  ref,
  rutin_id,
) async {
  return ref.watch(memberRequestProvider).seeAllMemberReq(rutin_id);
});

class MemberRequest {
  //
  //**********************   rutin all _members    *********** */
  Future<RoutineMembersModel?> all_members(String routineID) async {
    final header = await LocalData.getHeader();
    final Uri url = Uri.parse('${Const.BASE_URl}/routine/member/$routineID');

    try {
      // request
      final response = await http.post(url, headers: header);
      final res = jsonDecode(response.body);
      // get response
      if (response.statusCode == 200) {
        print(res);
        return RoutineMembersModel.fromJson(res);
      } else {
        print(res);
        throw Exception("failed to load all member list ");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //**********************   addMember   *********** */
  Future<String?> addMemberReq(rutin_id, username) async {
    final header = await LocalData.getHeader();
    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/routine/member/add/$rutin_id/$username'),
        headers: header,
      );

      var res = jsonDecode(response.body)["message"];

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("failed to load all member list ");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //**********************   remove members   *********** */
  Future<Message> removeMemberReq(rutin_id, username) async {
    final header = await LocalData.getHeader();
    var url = Uri.parse(
      '${Const.BASE_URl}/routine/member/remove/$rutin_id/$username',
    );

    try {
      final response = await http.post(url, headers: header);

      var res = jsonDecode(response.body);
      print(res);
      Message message = Message.fromJson(res);

      if (response.statusCode == 200) {
        return message;
      } else {
        throw Exception(message.message);
      }
    } catch (e) {
      print(e);
      throw Exception(Message(message: e.toString()));
    }
  }

  //.... add cap10s.../
  Future<String> addCaptressReq(routineId, username) async {
    final header = await LocalData.getHeader();
    print("hi i am calling req $routineId  $username");

    final url = Uri.parse('${Const.BASE_URl}/routine/captain/add');

    final response = await http.post(
      url,
      headers: header,
      body: {"routineId": routineId, "username": username},
    );

    var res = jsonDecode(response.body)['message'];

    print("add cap10 req :$res");
    try {
      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        return res;
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String?> removeCaptansReq(routineId, username) async {
    final header = await LocalData.getHeader();
    print("hi i am calling req $routineId  $username");

    final url = Uri.parse('${Const.BASE_URl}/routine/captain/remove');

    final response = await http.delete(
      url,
      headers: header,
      body: {"routineId": routineId, "username": username},
    );

    var res = jsonDecode(response.body)['message'];

    print("add cap10 req :$res");
    try {
      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        return res;
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<Either<String, Message>> sendRequest(String routineId) async {
    final header = await LocalData.getHeader();
    var url = Uri.parse(
      "${Const.BASE_URl}/routine/member/send_request/$routineId",
    );

    try {
      final response = await http.post(url, headers: header);

      var res = Message.fromJson(jsonDecode(response.body));
      print("req from  sendRequest ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return right(res);
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<Message, Message>> leaveRequest(rutin_id) async {
    final header = await LocalData.getHeader();
    var url = Uri.parse("${Const.BASE_URl}/routine/member/leave/$rutin_id");

    try {
      final response = await http.post(url, headers: header);

      print("req from  leave member ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        var res = Message.fromJson(jsonDecode(response.body));

        return right(res);
      } else {
        var res = Message.fromJson(jsonDecode(response.body));

        return left(res);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }

  //***********************   remove Members   ***********************/
  Future<Message> remove_member(routineID, memberID) async {
    final header = await LocalData.getHeader();
    var url = Uri.parse(
      "${Const.BASE_URl}/routine/member/kickout/$routineID/$memberID",
    );

    try {
      final response = await http.delete(url, headers: header);
      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return res;
      } else {
        throw Exception(res.toString());
      }
    } catch (e) {
      return Message(message: e.toString());
    }
  }

  //....see All members........//
  Future<RoutineMembersModel> seeAllMemberReq(String rutin_id) async {
    var url = Uri.parse("${Const.BASE_URl}/routine/member/$rutin_id");

    //
    final response = await http.post(url);
    var res = RoutineMembersModel.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    try {
      if (response.statusCode == 200) {
        return res;
      } else {
        throw Exception(res.message);
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
      print(e);
      rethrow;
    }
  }
  //... see all joi request ..............///

  //....sell all request ....//
  Future<SeeAllRequestModel> see_all_request(routineId) async {
    final header = await LocalData.getHeader();
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/member/see_all_request/$routineId',
    );
    try {
      final response = await http.post(url, headers: header);
      final res = jsonDecode(response.body);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        print(res);
        return SeeAllRequestModel.fromJson(res);
      } else {
        throw jsonDecode(response.body)['Message'];
      }
    } on io.SocketException catch (_) {
      throw Exception('Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('TimeOut Exception');
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //...acceptRequest.....//
  Future<Message> acceptRequest(routineID, username, {bool? acceptAll}) async {
    final header = await LocalData.getHeader();
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/member/accept_request/$routineID',
    );
    final Map<String, String> headers = header;
    print("$username");

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "username": username,
          'acceptAll': acceptAll == null ? 'false' : acceptAll.toString(),
        },
      );

      if (response.statusCode == 200) {
        var res = Message.fromJson(jsonDecode(response.body));
        print(res);
        return res;
      } else {
        var res = Message.fromJson(jsonDecode(response.body));
        return res;
      }
    } catch (e) {
      print(e);
      return Message(message: e.toString());
    }
  }

  //
  //...acceptRequest.....//
  Future<Message> rejectRequest(routineID, username) async {
    final header = await LocalData.getHeader();
    final Uri url = Uri.parse(
      '${Const.BASE_URl}/routine/member/reject_request/$routineID',
    );

    try {
      final response = await http.post(
        url,
        headers: header,
        body: {"username": username},
      );

      var res = Message.fromJson(jsonDecode(response.body));
      print('from response : ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return res;
      } else {
        throw res.message;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
