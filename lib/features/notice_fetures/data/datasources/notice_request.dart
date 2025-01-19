// ignore_for_file: avoid_print, unused_result, library_prefixes, unused_local_variable, unnecessary_null_comparison
import 'dart:io' as Io;
import 'package:mime/mime.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/constant.dart';
import '../../../../../core/local data/api_cashe_maager.dart';
import '../../../../../core/local data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../models/recent_notice_model.dart';

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
        var getdata = await MyApiCash.getData(key);
        print('From cash $getdata');
        return RecentNotice.fromJson(getdata);
      } else {
        final response = await http.post(
          requestUri,
          headers: headers,
        );
        final res = json.decode(response.body);

        if (response.statusCode == 200) {
          // save to cash
          MyApiCash.saveLocal(key: key, response: response.body);
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
    final url = Uri.parse('${Const.BASE_URl}/notice/add/');

    File thePdf = File(pdfFile!);
    String? mineType = lookupMimeType(pdfFile);

    //
    if (mineType != 'application/pdf') {
      return left('Only PDF file is allow');
    }

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['title'] = contentName ?? '';
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
    final responded = await http.Response.fromStream(response);
    final resData = json.decode(responded.body);
    //print(responseBytes);
    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        // final responseBytes = await response.stream.bytesToString();
        Message message = Message.fromJson(resData);
        return right(message.message);
      } else {
        print('response $resData');
        Message message = Message.fromJson(resData);
        return left(message.message);
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
      print('res trying to delete : $res');

      if (response.statusCode == 200) {
        Message message = Message.fromJson(res);

        return right(message);
      } else {
        Message message = Message.fromJson(res);

        return left(message);
      }
    } catch (e) {
      print('e trying to delete : $e');
      return left(Message(message: e.toString()));
    }
  }
}
