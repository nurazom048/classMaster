// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/captens/list_of_captens.dart';
import 'package:table/models/members_models.dart';
import '../../../../../constant/constant.dart';
import '../../../../../models/member/all_members.dart';
import '../../../../../models/message_model.dart';
import '../../../../../models/see_all_request_model.dart';

final memberRequestProvider = Provider((ref) => memberRequest());

class memberRequest {
//
//**********************   rutin all _members    *********** */
  Future<MembersModel?> all_members(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/$rutin_id'),
          headers: {'Authorization': 'Bearer $getToken'});

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(res);
        return MembersModel.fromJson(res);
      } else {
        throw Exception("faild to load all member list ");
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
        Uri.parse('${Const.BASE_URl}/rutin/member/remove//$rutin_id/$username');

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
  Future<String?> addCaptensReq(rutinid, position, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("hi i am calling req $rutinid , $position $username");

    final url = Uri.parse('${Const.BASE_URl}/rutin/cap10/add');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $getToken'
    }, body: {
      "rutinid": rutinid,
      "position": position ?? "ist cap 10 ",
      "username": username
    });

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

  Future<Message> leaveRequest(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/rutin/member/leave/$rutin_id");

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});

      var res = Message.fromJson(jsonDecode(response.body));
      print("req from  leave member ${res.message}");

      if (response.statusCode == 200) {
        return res;
      } else {
        throw Exception(res.message);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //
  Future<ListCptens> sellAllCaptemReq(String rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/rutin/cap10/$rutin_id");

    //
    final response = await http.post(url);
    var res = ListCptens.fromJson(jsonDecode(response.body));
    print("req from  leave member $res");

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

  //....see All members........//
  Future<AllMember> seeAllMemberReq(String rutin_id) async {
    var url = Uri.parse("${Const.BASE_URl}/rutin/member/$rutin_id");

    //
    final response = await http.post(url);
    var res = AllMember.fromJson(jsonDecode(response.body));

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
  Future<SeeAllRequestModel> sell_all_request(rutin_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/rutin/member/see_all_request/$rutin_id'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

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
  Future<Message> acceptRequest(rutinId, username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    print("$username");

    try {
      final response = await http.post(
          Uri.parse('${Const.BASE_URl}/rutin/member/acsept_request/$rutinId'),
          headers: {'Authorization': 'Bearer $getToken'},
          body: {"username": username});

      var res = Message.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        print(res);
        return res;
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
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

final allCaptenProvider =
    FutureProvider.family<ListCptens, String>((ref, rutin_id) async {
  return ref.watch(memberRequestProvider).sellAllCaptemReq(rutin_id);
});
final allMembersProvider =
    FutureProvider.family<AllMember, String>((ref, rutin_id) async {
  return ref.watch(memberRequestProvider).seeAllMemberReq(rutin_id);
});
