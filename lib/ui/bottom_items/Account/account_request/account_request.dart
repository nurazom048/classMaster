// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';

import '../../../../constant/constant.dart';
import '../../Home/utils/utils.dart';
import '../models/account_models.dart';

final AccountReqProvider = Provider<AccountReq>((ref) {
  return AccountReq();
});
//

final accountDataProvider = FutureProvider.autoDispose
    .family<AccountModels?, String?>((ref, username) async {
  return ref.watch(AccountReqProvider).getAccountData(username: username);
});

class AccountReq {
//... Account data...//
  Future<AccountModels> getAccountData({String? username}) async {
    final String? token = await AuthController.getToken();
    final url = username != null
        ? Uri.parse('${Const.BASE_URl}/account/$username')
        : Uri.parse('${Const.BASE_URl}/account/');
    final headers = {'Authorization': 'Bearer $token'};
    final bool isOnline = await Utils.isOnlineMethode();
    var isHaveCash = await APICacheManager().isAPICacheKeyExist(url.toString());
    try {
//
      // if offline and have cash
      if (!isOnline && isHaveCash) {
        //
        var getdata = await APICacheManager().getCacheData(url.toString());
        print('Foem cash $getdata');
        return AccountModels.fromJson(jsonDecode(getdata.syncData));
      }

// Request
      final response = await http.post(url, headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        //

        // save to csh
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: url.toString(), syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        // send responce

        return AccountModels.fromJson(json.decode(response.body));
      } else {
        throw 'Error retrieving account data';
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  // Future<AccountModels> accountData({String? username}) async {
  //   print("req usrname  : $username");

  //   final String? getToken = await AuthController.getToken();

  //   //... Url for my account and others account
  //   var url = username != null
  //       ? Uri.parse('${Const.BASE_URl}/account/$username')
  //       : Uri.parse('${Const.BASE_URl}/account/');
  //   Map<String, String>? headers = {'Authorization': 'Bearer $getToken'};
  //   try {
  //     final response = await http.post(url, headers: headers);
  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       return AccountModels.fromJson(json.decode(response.body));
  //     } else {
  //       throw "";
  //     }
  //   } catch (e) {
  //     print(e);
  //     return Future.error(e);
  //   }
  // }

//********************* update Account     ********************************//
  static Future<Message> updateAccount({
    required String name,
    required String username,
    required String about,
    String? profileImage,
    String? coverImage,
  }) async {
    print('form eddit account ************* $profileImage');
    try {
      // Get token from shared preferences
      final String? getToken = await AuthController.getToken();

      // Create URL
      final url = Uri.parse('${Const.BASE_URl}/account/eddit');

      // Create request
      final request = http.MultipartRequest('POST', url);

      // Set authorization header
      request.headers.addAll({'Authorization': 'Bearer $getToken'});

      // Add fields to request
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
