// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';

import '../../../../../constant/constant.dart';
import '../../utils/utils.dart';
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
    // Url
    final Uri recentNoticeUri =
        Uri.parse('${Const.BASE_URl}/notice/recent$morepage');
    final Uri viewNoticeByAcademyIDUri =
        Uri.parse('${Const.BASE_URl}/notice/recent/$academyID$morepage');
    final Uri requestUri =
        academyID == null ? recentNoticeUri : viewNoticeByAcademyIDUri;
    final key = requestUri.toString();

    final bool isOffline = await Utils.isOnlineMethode();
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(key);
    try {
      // if offline and have cash

      if (isOffline && isHaveCash) {
        var getdata = await APICacheManager().getCacheData(key);
        print('Foem cash $getdata');
        return RecentNotice.fromJson(jsonDecode(getdata.syncData));
      }

      final response = await http
          .post(requestUri, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);

      if (response.statusCode == 200) {
        // save to csh
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: key, syncData: response.body);

        await APICacheManager().addCacheData(cacheDBModel);

        return RecentNotice.fromJson(res);
      } else {
        final message = Message.fromJson(json.decode(response.body));
        throw message.message;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //******    add notice     ********* */
  Future<String> addNotice({
    String? contentName,
    String? description,
    String? pdfFile,
  }) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    var url = Uri.parse('${Const.BASE_URl}/notice/add/');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $getToken',
      "Access-Control-Allow-Origin": "*",
    });

    request.fields['content_name'] = contentName ?? '';
    request.fields['description'] = description ?? '';
    if (pdfFile != null) {
      try {
        final pdfPath = await http.MultipartFile.fromPath('pdf_file', pdfFile);
        print("pdf path: $pdfFile");
        request.files.add(pdfPath);
      } catch (e) {
        print("Eror***** : $e");
      }
    }

    final response = await request.send();
    print(await response.stream.bytesToString());
    print(response.statusCode);

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
