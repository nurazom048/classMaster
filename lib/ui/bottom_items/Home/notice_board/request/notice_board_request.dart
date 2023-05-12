// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:http/http.dart' as http;

import '../../../../../constant/constant.dart';
import '../../../../../models/chack_status_model.dart';
import '../models/all_members_model.dart';
import '../models/list_noticeboard.dart';
import '../models/notices models/list_ofz_notices.dart';

//
final uploadedNoticeBoardProvider =
    FutureProvider<ListOfNoticeBoard>((ref) async {
  return ref.read(noticeBoardRequestProvider).uploadedNoticeBoard();
});

final noticeBoardchackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, noticeBoardId) {
  return ref.read(noticeBoardRequestProvider).chackStatus(noticeBoardId);
});

final noticeBoardRequestProvider =
    Provider<NoticeBoardRequest>((ref) => NoticeBoardRequest());

class NoticeBoardRequest {
  //******    createTedNoticeBoardNAme    ********* */
  Future<ListOfNoticeBoard> uploadedNoticeBoard() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/all_notice_board'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        return ListOfNoticeBoard.fromJson(res);
      } else {
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      print(e);
      return throw Future.error(e);
    }
  }

  //******    joinedNoticeList    ********* */
  Future<ListOfNoticeBoard> joinedNoticeList() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/all_notice_board'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        print(res);
        return ListOfNoticeBoard.fromJson(res);
      } else {
        //
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      return throw Future.error(e);
    }
  }

  //

  //******    getNoticesByNoticeBoardId    ********* */
  Future<ListOfNoticesModel> getNoticesByNoticeBoardId(String noticeBoardId,
      {dynamic page}) async {
    print("frpm request");
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    String more = page != null ? "?page=$page" : "";

    final response = await http.get(
        Uri.parse('${Const.BASE_URl}/notice/$noticeBoardId/notices$more'),
        headers: {'Authorization': 'Bearer $getToken'});
    final res = json.decode(response.body);
    print(res);
    try {
      if (response.statusCode == 200) {
        print(res);
        return ListOfNoticesModel.fromJson(res);
      } else {
        //
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      print(e);
      return throw Future.error(e);
    }
  }

  // //
  //   //******    see all joined request     ********* */
  // Future<JoinRequestsResponseModel> joinedNoticeList(
  //     String noticeBoardId) async {
  //   // Obtain shared preferences.
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');

  //   final response = await http.get(
  //       Uri.parse('${Const.BASE_URl}/notice/viewRequest/$noticeBoardId'),
  //       headers: {'Authorization': 'Bearer $getToken'});
  //   final res = json.decode(response.body);
  //   JoinRequestsResponseModel list = JoinRequestsResponseModel.fromJson(res);

  //   try {
  //     if (response.statusCode == 200) {
  //       return list;
  //     } else {
  //       //
  //       Message message = Message.fromJson(json.decode(response.body));
  //       return throw Future.error(message.message);
  //     }
  //   } catch (e) {
  //     print(e);
  //     return throw Future.error(e);
  //   }
  // }

  // send join request
  Future<Either<String, Message>> sendRequest(String noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    var url = Uri.parse("${Const.BASE_URl}/notice/sendRequest/$noticeBoardId");

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

  Future<CheckStatusModel> chackStatus(String noticeBoardId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/status/$noticeBoardId'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      if (response.statusCode == 200) {
        CheckStatusModel res =
            CheckStatusModel.fromJson(jsonDecode(response.body));
        print("res  ${jsonDecode(response.body)}");
        return res;
      } else {
        throw Exception("Response body is null");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //******   seel all members    ********* */
  Future<AllMembersModel> seeAllMembers(String noticeBoardId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.get(
        Uri.parse('${Const.BASE_URl}/notice/members/$noticeBoardId'),
        headers: {'Authorization': 'Bearer $getToken'});
    final res = json.decode(response.body);
    AllMembersModel list = AllMembersModel.fromJson(res);

    try {
      if (response.statusCode == 200) {
        return list;
      } else {
        //
        Message message = Message.fromJson(json.decode(response.body));
        return throw Future.error(message.message);
      }
    } catch (e) {
      print(e);
      return throw Future.error(e);
    }
  }
}
