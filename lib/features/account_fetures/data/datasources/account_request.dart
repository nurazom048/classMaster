import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constant/constant.dart';
import '../../../../core/local data/api_cashe_maager.dart';
import '../../../../core/local data/local_data.dart';
import '../../../../core/models/message_model.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../models/account_models.dart';

// Provider for AccountReq instance
final accountReqProvider = Provider<AccountReq>((ref) => AccountReq());

// FutureProvider for fetching account data
final accountDataProvider =
    FutureProvider.family<AccountModels?, String?>((ref, username) async {
  final accountReq = ref.watch(accountReqProvider);
  return accountReq.getAccountData(username: username);
});

class AccountReq {
  // Fetches account data from API or cache
  Future<AccountModels> getAccountData({String? username}) async {
    final headers = await LocalData.getHeader();
    final url = Uri.parse('${Const.BASE_URl}/account/${username ?? ''}');
    final cacheKey = url.toString();

    final isOnline = await Utils.isOnlineMethod();
    final hasCache = await MyApiCache.haveCache(cacheKey);

    try {
      // If offline and cache exists, return cached data
      if (!isOnline && hasCache) {
        return AccountModels.fromJson(await MyApiCache.getData(cacheKey));
      }

      // Make API request
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        await MyApiCache.saveLocal(key: cacheKey, response: response.body);
        return AccountModels.fromJson(json.decode(response.body));
      }
      throw Exception(json.decode(response.body)['message'] ?? 'Unknown error');
    } on io.SocketException {
      // Return cached data if available
      if (hasCache) {
        return AccountModels.fromJson(await MyApiCache.getData(cacheKey));
      }
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      if (hasCache) {
        return AccountModels.fromJson(await MyApiCache.getData(cacheKey));
      }
      throw Exception('An unexpected error occurred');
    }
  }

//********************* update Account     ********************************//
  static Future<Message> updateAccount({
    required String name,
    required String username,
    required String about,
    String? profileImage,
    String? coverImage,
  }) async {
    print('form edit account ************* $profileImage');
    try {
      // Get token from shared preferences
      final headers = await LocalData.getHeader();
      // Create URL
      final url = Uri.parse('${Const.BASE_URl}/account/edit');

      // Create request
      final request = http.MultipartRequest('POST', url);

      // Set authorization header and fields
      request.headers.addAll(headers);
      request.fields['name'] = name;
      request.fields['username'] = username;
      request.fields['about'] = about;

      // Add image to request if imagePath is provided
      if (profileImage != null) {
        final image = await http.MultipartFile.fromPath('image', profileImage);
        request.files.add(image);
      }
      if (coverImage != null) {
        final cover = await http.MultipartFile.fromPath('cover', coverImage);
        request.files.add(cover);
      }

      // Send request and get response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("response $response");

      // Parse response body
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print("result $result");

      // Check status code
      if (streamedResponse.statusCode == 200) {
        print('Account updated successfully');
        return Message(message: 'Account updated successfully');
      } else {
        print('Failed to update account: ${streamedResponse.statusCode}');
        throw Exception(
            'Failed to update account: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error updating account: $e');
      return Message(message: 'Failed to update account: $e');
    }
  }
}
