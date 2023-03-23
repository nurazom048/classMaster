// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, unused_local_variable, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/captens/listOfCaptens.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/see_all_members.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/sell_all_captens.dart';
import '../../../../../models/messageModel.dart';

class memberRequest extends StateNotifier<bool> {
  memberRequest() : super(true);
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
        if (response.body != null) {
          print(res);
          return MembersModel.fromJson(res);
        } else {
          throw Exception("faild to load all member list ");
        }
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
      print("req from  sendRequest $res");

      if (response.statusCode == 200) {
        return right(res);
      } else {
        return right(res);
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Message?> leaveRequest(rutin_id) async {
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
        return res;
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
    print("req from  leave member ${res}");

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
}

final memberRequestProvider = StateNotifierProvider((ref) => memberRequest());

final lavePr = FutureProvider.family<Message?, String>((ref, rutin_id) async {
  return ref.watch(memberRequestProvider.notifier).leaveRequest(rutin_id);
});
final allCaptenProvider =
    FutureProvider.family<ListCptens, String>((ref, rutin_id) async {
  return ref.watch(memberRequestProvider.notifier).sellAllCaptemReq(rutin_id);
});
