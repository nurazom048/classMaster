// ignore_for_file: avoid_print, unused_result, library_prefixes, unused_local_variable, unnecessary_null_comparison
import 'dart:io' as Io;
import 'package:mime/mime.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';

import '../../../../../constant/constant.dart';
import '../../../../../local data/api_cashe_maager.dart';
import '../../../../../local data/local_data.dart';
import '../../utils/utils.dart';
import '../models/recent_notice_model.dart';

// final viewNoticeByUsernameProvider =
//     FutureProvider<Either<String, RecentNotice>>((ref) async {
//   return ref.read(noticeReqProvider).recentNotice(academyID: );
// });

// recent notice
final recentNoticeProvider = FutureProvider<RecentNotice>((ref) async {
  return ref.read(noticeReqProvider).recentNotice();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

class NoticeRequest {
  //******    recentNotice    ********* */
  Future<RecentNotice> recentNotice({dynamic page, String? academyID}) async {
    final headers = await LocalData.getHerder();
    final String morepage = page == null ? '' : "?page=$page";
    // Url
    final Uri recentNoticeUri =
        Uri.parse('${Const.BASE_URl}/notice/recent$morepage');
    final Uri viewNoticeByAcademyIDUri =
        Uri.parse('${Const.BASE_URl}/notice/recent/$academyID$morepage');
    final Uri requestUri =
        academyID == null ? recentNoticeUri : viewNoticeByAcademyIDUri;
    final key = requestUri.toString();

    final bool isOffline = await Utils.isOnlineMethod();
    var isHaveCash = await MyApiCash.haveCash(key);
    try {
      // if offline and have cash

      if (!isOffline && isHaveCash) {
        var getdata = await APICacheManager().getCacheData(key);
        print('From cash $getdata');
        return RecentNotice.fromJson(jsonDecode(getdata.syncData));
      } else {
        final response = await http.post(
          requestUri,
          headers: headers,
        );
        final res = json.decode(response.body);

        if (response.statusCode == 200) {
          // save to csh
          MyApiCash.saveLocal(key: key, syncData: response.body);
          print(res);

          return RecentNotice.fromJson(res);
        } else {
          print(json.decode(response.body));
          final message = Message.fromJson(json.decode(response.body));

          throw message.message;
        }
      }
    } on Io.SocketException catch (_) {
      throw Exception('Not connected. Failed to load data');
    } on TimeoutException catch (_) {
      throw Exception('Not connected. TimeOut Exception');
    } catch (e) {
      rethrow;
    }
  }

  //******    add notice     ********* */
  Future<Either<String, String>> addNotice({
    String? contentName,
    String? description,
    String? pdfFile,
    required WidgetRef ref,
  }) async {
    // Obtain shared preferences.

    final headers = await LocalData.getHerder();

    var url = Uri.parse('${Const.BASE_URl}/notice/add/');

    File thePdf = File(pdfFile!);
    String? mineType = lookupMimeType(pdfFile);

    //
    if (mineType != 'application/pdf') {
      return left('Only PDF file is allow');
    }

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['content_name'] = contentName ?? '';
    request.fields['description'] = description ?? '';
    request.fields['mimetypeChecked'] = "true";

    if (pdfFile != null) {
      try {
        final pdfPath = await http.MultipartFile.fromPath('pdf_file', pdfFile);
        print("pdf path: $pdfFile");
        request.files.add(pdfPath);
      } catch (e) {
        return left("$e");
      }
    }

    final response = await request.send();
    final responced = await http.Response.fromStream(response);
    final resData = json.decode(responced.body);
    //print(responseBytes);
    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        // final responseBytes = await response.stream.bytesToString();
        print('response');
        print(resData);
        return right('Notice uploaded successfully');
      } else {
        return left("Server error");
      }
    } catch (e) {
      print(e.toString());
      return left("$e");
    }
  }

  //******    DELETE Notice     ********* */
  Future<Either<Message, Message>> deleteNotice({
    required String noticeId,
  }) async {
    final headers = await LocalData.getHerder();

    var url = Uri.parse('${Const.BASE_URl}/notice/$noticeId');

    try {
      final response = await http.delete(url, headers: headers);
      final res = json.decode(response.body);

      if (response.statusCode == 200) {
        Message message = Message.fromJson(res);
        print(res);

        return right(message);
      } else {
        Message message = Message.fromJson(res);

        return left(message);
      }
    } catch (e) {
      return left(Message(message: e.toString()));
    }
  }
}
