// ignore_for_file: avoid_print, unused_result, library_prefixes, unused_local_variable, unnecessary_null_comparison
import 'dart:io' as Io;
import 'package:classmate/features/notice_fetures/domain/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constant/constant.dart';
import '../../../../core/local data/api_cache_manager.dart';
import '../../../../../core/local data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../../domain/interface/pdf_interface.dart' show PdfFileData;
import '../models/recent_notice_model.dart';

// recent notice
final recentNoticeProvider = FutureProvider<RecentNotice>((ref) async {
  return ref.read(noticeReqProvider).fetchRecentNotice();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

class NoticeRequest implements NoticeRepository {
  //******    recentNotice    ********* */
  @override
  Future<RecentNotice> fetchRecentNotice({int? page, String? academyId}) async {
    final headers = await LocalData.getHeader();
    print("Headers before sending request: $headers");

    // Construct URL
    final pageQuery = page == null ? '' : "?page=$page";
    final baseUrl = Const.BASE_URl;
    final recentNoticeUrl = Uri.parse('$baseUrl/notice/recent$pageQuery');
    final academyNoticeUrl = Uri.parse(
      '$baseUrl/notice/recent/$academyId$pageQuery',
    );
    final requestUrl = academyId == null ? recentNoticeUrl : academyNoticeUrl;
    final cacheKey = requestUrl.toString();

    // Check connectivity and cache
    final isOnline = await Utils.isOnlineMethod();
    final hasCache = await MyApiCache.haveCache(cacheKey);

    try {
      // Return cached data if offline and cache exists
      if (!isOnline && hasCache) {
        final cachedData = await MyApiCache.getData(cacheKey);
        print('From cache: $cachedData');
        return RecentNotice.fromJson(cachedData);
      }

      // Make API request
      final response = await http.post(requestUrl, headers: headers);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Cache successful response
        await MyApiCache.saveLocal(key: cacheKey, response: response.body);
        print(responseData);
        return RecentNotice.fromJson(responseData);
      } else {
        print(responseData);
        final errorMessage = Message.fromJson(responseData);
        throw errorMessage.message;
      }
    } on Io.SocketException {
      throw Exception('Not connected. Failed to load data');
    } on TimeoutException {
      throw Exception('Connection timed out');
    } catch (e) {
      rethrow;
    }
  }

  //******    add notice     ********* */
  @override
  Future<Either<String, String>> addNotice({
    String? contentName,
    String? description,
    PdfFileData? pdfFileData,
    required WidgetRef ref,
  }) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/notice/add/');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['title'] = contentName ?? '';
    request.fields['description'] = description ?? '';
    request.fields['mimetypeChecked'] = "true";

    if (pdfFileData != null) {
      try {
        if (kIsWeb) {
          if (pdfFileData.bytes != null) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'pdf_file',
                pdfFileData.bytes!,
                filename: pdfFileData.name,
              ),
            );
          } else {
            return left('No PDF bytes provided on web');
          }
        } else {
          if (pdfFileData.path != null) {
            final pdfPath = await http.MultipartFile.fromPath(
              'pdf_file',
              pdfFileData.path!,
            );
            request.files.add(pdfPath);
          } else {
            return left('No PDF path provided on non-web');
          }
        }
      } catch (e) {
        return left("Error uploading PDF: $e");
      }
    }

    final response = await request.send();
    final responded = await http.Response.fromStream(response);
    final resData = json.decode(responded.body);
    print("Response status: ${response.statusCode}");
    print("Response data: $resData");

    try {
      if (response.statusCode == 200) {
        Message message = Message.fromJson(resData);
        return right(message.message);
      } else {
        Message message = Message.fromJson(resData);
        return left(message.message);
      }
    } catch (e) {
      print(e.toString());
      return left("$e");
    }
  }

  //******    DELETE Notice     ********* */
  @override
  Future<Either<Message, Message>> deleteNotice({
    required String noticeId,
  }) async {
    final headers = await LocalData.getHeader();
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
