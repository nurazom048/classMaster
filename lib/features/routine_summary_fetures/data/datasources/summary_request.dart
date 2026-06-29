// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:classmate/features/routine_summary_fetures/data/implements/routine_summary_imp.dart';
import 'package:classmate/features/routine_summary_fetures/data/models/all_summary_models.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/socket_services/socketCon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/export_core.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../routine/data/models/check_status_model.dart';
import 'package:http/http.dart' as http;

// ... Providers....//
final summaryReqProvider = Provider<SummaryRepository>(
  (ref) => SummaryRepository(),
);

class SummaryRepository implements ISummaryRepository {
  // 🔗 আপনার API এর বেস URL
  final String baseUrl = '${Const.BASE_URl}/summary';

  @override
  Future<bool> addSummary({
    required String classId,
    String? message,
    List<String>? externalLinks,
    List<XFile>? files, // 🔥 XFile parameter
  }) async {
    final Map<String, String> headers = await LocalData.getHeader();
    final uri = Uri.parse('$baseUrl/class/$classId');

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add Text fields
      if (message != null && message.trim().isNotEmpty) {
        request.fields['message'] = message;
      }

      // Send external links as JSON string for backend
      if (externalLinks != null && externalLinks.isNotEmpty) {
        request.fields['externalLinks'] = jsonEncode(externalLinks);
      }

      // Add Files with cross-platform support (Web & Mobile)
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          if (kIsWeb) {
            // 🔥 Web Specific Logic
            final bytes = await file.readAsBytes();
            request.files.add(
              http.MultipartFile.fromBytes(
                'files', // Must match multer 'files' in backend
                bytes,
                filename: file.name,
              ),
            );
          } else {
            // 📱 Mobile Specific Logic
            request.files.add(
              await http.MultipartFile.fromPath('files', file.path),
            );
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final resData = json.decode(response.body);

      if (response.statusCode == 201) {
        return true;
      } else {
        throw resData['message'] ?? 'Failed to add summary';
      }
    } catch (e) {
      throw Exception('Error adding summary: $e');
    }
  }

  // ------------------------------------------
  // 📚 1. GET SUMMARIES (Mapped to AllSummaryModel)
  // ------------------------------------------
  @override
  Future<AllSummaryModel> getSummaries({
    String? classId,
    String? type,
    int page = 1,
    int limit = 10,
  }) async {
    final headers = await LocalData.getHeader();

    // Build query parameters based on route logic
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (type == 'saved') {
      queryParams['type'] = 'saved';
    } else if (classId != null) {
      queryParams['classId'] = classId;
    } else {
      throw Exception('Must provide either classId or type="saved"');
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: headers);
      final resData = json.decode(response.body);

      if (response.statusCode == 200) {
        return AllSummaryModel.fromJson(resData);
      } else {
        throw resData['message'] ?? 'Failed to fetch summaries';
      }
    } catch (e) {
      throw Exception('Error fetching summaries: $e');
    }
  }

  // ------------------------------------------
  // 🗑️ 3. REMOVE SUMMARY
  // ------------------------------------------
  @override
  Future<bool> removeSummary(String summaryId) async {
    final headers = await LocalData.getHeader();
    final uri = Uri.parse('$baseUrl/$summaryId');

    try {
      final response = await http.delete(uri, headers: headers);
      final resData = json.decode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw resData['message'] ?? 'Failed to delete summary';
      }
    } catch (e) {
      throw Exception('Error deleting summary: $e');
    }
  }

  // ------------------------------------------
  // 📊 4. GET SUMMARY STATUS
  // ------------------------------------------
  @override
  Future<Map<String, dynamic>> getSummaryStatus(String summaryId) async {
    final headers = await LocalData.getHeader();
    final uri = Uri.parse('$baseUrl/$summaryId');

    try {
      final response = await http.get(uri, headers: headers);
      final resData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'summaryOwner': resData['summaryOwner'] ?? false,
          'isOwner': resData['isOwner'] ?? false,
          'isCaptain': resData['isCaptain'] ?? false,
          'isSummarySaved': resData['isSummarySaved'] ?? false,
        };
      } else {
        throw resData['message'] ?? 'Failed to fetch status';
      }
    } catch (e) {
      throw Exception('Error fetching summary status: $e');
    }
  }

  // ------------------------------------------
  // 🔖 5. TOGGLE SAVE SUMMARY
  // ------------------------------------------
  @override
  Future<bool> toggleSaveSummary({
    required String summaryId,
    required bool save,
  }) async {
    final headers = await LocalData.getHeader();
    final uri = Uri.parse('$baseUrl/$summaryId/save-toggle');

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'summaryId': summaryId, 'save': save}),
      );

      final resData = json.decode(response.body);

      if (response.statusCode == 200) {
        return resData['save'] as bool;
      } else {
        throw resData['message'] ?? 'Failed to toggle save state';
      }
    } catch (e) {
      throw Exception('Error toggling save: $e');
    }
  }
}
