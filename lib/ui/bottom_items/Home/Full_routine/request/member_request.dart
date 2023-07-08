// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/models/members_models.dart';
import '../../../../../constant/constant.dart';
import '../../../../../models/message_model.dart';
import '../../../../../models/see_all_request_model.dart';

final memberRequestProvider = Provider((ref) => MemberRequest());

class MemberRequest {
//
//**********************   rutin all _members    *********** */
  Future<RoutineMembersModel?> all_members(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(res);
        return RoutineMembersModel.fromJson(res);
      } else {
        throw Exception("failed to load all member list ");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

//**********************   addMember   *********** */
  Future<String?> addMemberReq(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/add/$rutin_id/$username'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body)["message"];

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("faild to load all member list ");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

//**********************   remove members   *********** */
  Future<Message> removeMemberReq(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url =
        Uri.parse('${Const.BASE_URl}/rutin/member/remove/$rutin_id/$username');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

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
  Future<String?> addCaptressReq(rutinid, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("hi i am calling req $rutinid  $username");

    final url = Uri.parse('${Const.BASE_URl}/rutin/cap10/add');

    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"rutinid": rutinid, "username": username});

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

  Future<String?> removeCaptansReq(rutinid, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("hi i am calling req $rutinid  $username");

    final url = Uri.parse('${Const.BASE_URl}/rutin/cap10/remove');

    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"rutinid": rutinid, "username": username});

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

  Future<Either<String, Message>> sendRequest(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url =
        Uri.parse("${Const.BASE_URl}/rutin/member/send_request/$rutin_id");

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

      var res = Message.fromJson(jsonDecode(response.body));
      print("req from  sendRequest ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return right(res);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<Message, Message>> leaveRequest(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/rutin/member/leave/$rutin_id");

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

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

//***********************   kickOut   ***********************/
  Future<Message> kickOut(rutin_id, memberid) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url =
        Uri.parse("${Const.BASE_URl}/rutin/member/kickout/$rutin_id/$memberid");

    try {
      final response = await http
          .delete(url, headers: {'Authorization': 'Bearer $getToken'});
      print("from kicked");
      print(jsonDecode(response.body));

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
    var url = Uri.parse("${Const.BASE_URl}/rutin/member/$rutin_id");

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
    } catch (e) {
      throw Exception(e);
    }
  }
  //... see all joi request ..............///

  //....sell all request ....//
  Future<SeeAllRequestModel> see_all_request(rutin_id) async {
    print("request canme to seeAll members $rutin_id");
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    Uri url =
        Uri.parse('${Const.BASE_URl}/rutin/member/see_all_request/$rutin_id');
    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $getToken'},
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        // ignore: unnecessary_null_comparison
        if (response.body != null) {
          SeeAllRequestModel res =
              SeeAllRequestModel.fromJson(jsonDecode(response.body));
          print(res);
          return res;
        } else {
          throw Exception("Response body is null");
        }
      } else {
        throw Exception("Failed to load status");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //...acceptRequest.....//
  Future<Message> acceptRequest(rutinId, username, {bool? acceptAll}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("$username");

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/acsept_request/$rutinId'),
          headers: {
            'Authorization': 'Bearer $getToken'
          },
          body: {
            "username": username,
            'acceptAll': acceptAll == null ? 'false' : acceptAll.toString(),
          });

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
  Future<Message> rejectRequest(rutin_id, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("$username");

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/reject_request/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'},
          body: {"username": username});

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        return res;
      } else {
        throw Exception(res.message);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}

final allMembersProvider =
    FutureProvider.family<RoutineMembersModel, String>((ref, rutin_id) async {
  return ref.watch(memberRequestProvider).seeAllMemberReq(rutin_id);
});
