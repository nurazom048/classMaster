// ignore_for_file: avoid_print, unused_result, library_prefixes, unused_local_variable, unnecessary_null_comparison
import 'dart:io' as Io;
import 'package:classmate/features/notice_fetures/domain/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import 'package:classmate/core/constant/constant.dart';
import '../../../../core/local_data/api_cache_manager.dart';
import 'package:classmate/core/local_data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../../domain/interface/pdf_interface.dart' show PdfFileData;
import '../models/recent_notice_model.dart';

// recent notice
final recentNoticeProvider = FutureProvider<RecentNotice>((ref) async {
  return ref.read(noticeReqProvider).fetchRecentNotice();
});

final noticeReqProvider = Provider<NoticeRequest>((ref) => NoticeRequest());

// ============================================================================
// 1. NOTICE REQUESTS (General Notices)
// ============================================================================
class NoticeRequest implements NoticeRepository {
  //****** Fetch Recent Notice ********* */
  @override
  Future<RecentNotice> fetchRecentNotice({
    int? page,
    String? academyId,
    String category = 'all',
  }) async {
    // Step 1: Get authentication headers
    final headers = await LocalData.getHeader();
    print("Headers before sending request: $headers");

    // ডাইনামিক URL বিল্ডিং
    String urlString =
        academyId != null
            ? '${Const.BASE_URl}/notice/academy/$academyId'
            : '${Const.BASE_URl}/notice/';

    final uri = Uri.parse(urlString).replace(
      queryParameters: {
        'page': page.toString(),
        'limit': '10',
        'category': category, // 🎯 ফিল্টার প্যারামিটার পাঠানো হচ্ছে
      },
    );
    final cacheKey = uri.toString();

    // Step 3: Check network connectivity and local cache
    final isOnline = await Utils.isOnlineMethod();
    final hasCache = await MyApiCache.haveCache(cacheKey);

    try {
      // Step 4: Return cached data if offline and cache exists
      if (!isOnline && hasCache) {
        final cachedData = await MyApiCache.getData(cacheKey);
        print('From cache: $cachedData');
        return RecentNotice.fromJson(cachedData);
      }

      // Step 5: Make GET API request to the backend
      final response = await http.get(uri, headers: headers); // Changed to GET
      final responseData = json.decode(response.body);

      // Step 6: Handle Response
      if (response.statusCode == 200) {
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

  // get notice by id..
  // In your notice_api_requests.dart file
  @override
  Future<Notice> getNoticeById({required String noticeId}) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/notice/$noticeId');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Access the "notice" key specifically
        return Notice.fromJson(responseData['notice']);
      } else {
        throw Exception('Failed to fetch notice: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notice: $e');
    }
  }

  //****** Add Notice ********* */
  @override
  Future<Either<String, String>> addNotice({
    String? contentName,
    String? description,
    PdfFileData? pdfFileData,
    String category = 'notice',
    required WidgetRef ref,
  }) async {
    try {
      // Step 1: Get authentication headers
      final headers = await LocalData.getHeader();

      // Step 2: Construct POST URL (Updated to POST /notice)
      final url = Uri.parse('${Const.BASE_URl}/notice');

      // Step 3: Initialize Multipart Request
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields['title'] = contentName ?? '';
      request.fields['description'] = description ?? '';
      request.fields['category'] = category;
      request.fields['mimetypeChecked'] = "true";

      // Step 4: Attach PDF file based on platform (Web vs Mobile)
      if (pdfFileData != null) {
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
      }

      // Step 5: Send Request and await response
      final response = await request.send();
      final responded = await http.Response.fromStream(response);
      
      dynamic resData;
      try {
        resData = json.decode(responded.body);
      } catch (e) {
        return left("Server returned an invalid response (status code: ${response.statusCode})");
      }

      print("Response status: ${response.statusCode}");
      print("Response data: $resData");

      // Step 6: Handle Success or Failure
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

  //****** DELETE Notice ********* */
  @override
  Future<Either<Message, Message>> deleteNotice({
    required String noticeId,
  }) async {
    // Step 1: Get headers and setup DELETE URL
    final headers = await LocalData.getHeader();
    var url = Uri.parse('${Const.BASE_URl}/notice/$noticeId');

    try {
      // Step 2: Send DELETE request
      final response = await http.delete(url, headers: headers);
      final res = json.decode(response.body);
      print('res trying to delete : $res');

      // Step 3: Parse and return Message
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
