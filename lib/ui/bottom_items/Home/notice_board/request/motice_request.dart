import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';

import '../../../../../constant/constant.dart';
import '../models/recent_notice_model.dart';

// final viewNoticeByUsernameProvider =
//     FutureProvider<Either<String, RecentNotice>>((ref) async {
//   return ref.read(noticeReqProvider).recentNotice(academyID: );
// });

// recet notice
final recentNoticeProvider = FutureProvider<RecentNotice>((ref) async {
  return ref.read(noticeReqProvider).recentNotice();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

class NoticeRequest {
  //******    recentNotice    ********* */
  Future<RecentNotice> recentNotice({dynamic page, String? academyID}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    final String morepage = page == null ? '' : "?page=$page";

    final Uri recentNoticeUri =
        Uri.parse('${Const.BASE_URl}/notice/recent$morepage');
    final Uri viewNoticeByAcademyIDUri =
        Uri.parse('${Const.BASE_URl}/notice/recent/academyID/$morepage');

    final Uri requestUri =
        academyID == null ? recentNoticeUri : viewNoticeByAcademyIDUri;

    final response = await http
        .post(requestUri, headers: {'Authorization': 'Bearer $getToken'});
    final res = json.decode(response.body);

    try {
      if (response.statusCode == 200) {
        return RecentNotice.fromJson(res);
      } else {
        final message = Message.fromJson(json.decode(response.body));
        throw Future.error(message.message);
      }
    } catch (e) {
      throw Future.error(e);
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
