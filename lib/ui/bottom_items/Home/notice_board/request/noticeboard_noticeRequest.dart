// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/notice%20bord/ceatedNoticeBordName.dart';

import '../../../../../constant/constant.dart';
import '../models/notice bord/list_of_notice model.dart';
import '../models/notice bord/recentNotice.dart';

final viewNoticeByUsernameProvider =
    FutureProvider<Either<String, NoticesResponse>>((ref) async {
  return ref.read(noticeReqProvider).viewNoticeByUsername();
});

// recet notice
final recentNoticeProvider = FutureProvider<RecentNotice>((ref) async {
  return ref.read(noticeReqProvider).recentNotice();
});

// recet notice
final createdNoticeBoardNmae =
    FutureProvider<NoticeBoardListModel>((ref) async {
  return ref.read(noticeReqProvider).cretedNoticeBoardNAme();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

class NoticeRequest {
//******    create a new noticeBoard     ********* */

  Future<Either<String, Message>> createAnewNoticeBoard(
      {required String name, required String about}) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/create'),
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"name": name, "description": about});
    final res = json.decode(response.body);
    Message message = Message.fromJson(res);
    print(res.toString());

    try {
      if (response.statusCode == 200) {
        print(message);
        return right(message);
      } else {
        return left(res.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }

//******    view All notice by username    ********* */
  Future<Either<String, NoticesResponse>> viewNoticeByUsername() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.get(Uri.parse('${Const.BASE_URl}/notice/qq'),
        headers: {'Authorization': 'Bearer $getToken'});

    try {
      if (response.statusCode == 200) {
        final res = json.decode(response.body);

        print(res);
        return right(NoticesResponse.fromJson(res));
      } else {
        return left("error");
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  //******    recentNotice    ********* */
  Future<RecentNotice> recentNotice({dynamic page}) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    String morepage = page == null ? '' : "?page=$page";

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/recent$morepage'),
        headers: {'Authorization': 'Bearer $getToken'});
    final res = json.decode(response.body);

    print(res);

    try {
      if (response.statusCode == 200) {
        return RecentNotice.fromJson(res);
      } else {
        Message message = Message.fromJson(json.decode(response.body));
        throw Future.error(message.message);
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  //******    createTedNoticeBoardNAme    ********* */
  Future<NoticeBoardListModel> cretedNoticeBoardNAme() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.post(
        Uri.parse('${Const.BASE_URl}/notice/all_notice_board'),
        headers: {'Authorization': 'Bearer $getToken'});

    final Map<String, dynamic> res = json.decode(response.body);

// Print the response body
    print("All notice board: $res");

    try {
      if (response.statusCode == 200) {
        return NoticeBoardListModel.fromJson(res as Map<String, dynamic>);
      } else {
        throw "";
      }
    } catch (e) {
      throw e;
    }
  }

  //******    add notice     ********* */
  Future<String> addNotice({
    String? noticeId,
    String? content_name,
    String? description,
    String? pdf_file,
  }) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/notice/add/$noticeId');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({'Authorization': 'Bearer $getToken'});

    request.fields['content_name'] = content_name ?? '';
    request.fields['description'] = description ?? '';
    if (pdf_file != null) {
      final pdfPath = await http.MultipartFile.fromPath('pdf_file', pdf_file);
      print("pdf path: $pdf_file");
      request.files.add(pdfPath);
    }

    final response = await request.send();

    try {
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return responseBody;
      } else {
        throw "Server error";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
