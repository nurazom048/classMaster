// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';

import '../models/Account_models.dart';

final AccountReqProvider = Provider<AccountReq>((ref) {
  return AccountReq();
});
//
final accountDataProvider =
    FutureProvider.family<AccountModels?, String?>((ref, username) async {
  return ref.read(AccountReqProvider).accountData(username);
});

class AccountReq {
//... Account data...//
  Future<AccountModels?> accountData(String? username) async {
    print("req usrname  : $username");

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    //... Url for my account and others account
    var url = username != null
        ? Uri.parse('${Const.BASE_URl}/account/$username')
        : Uri.parse('${Const.BASE_URl}/account/');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $getToken'});
      final res = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        return AccountModels.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

//********************* update Account     ********************************//
  static Future<void> updateAccount(context, name, username, about,
      {String? imagePath}) async {
    try {
      // Get token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final String? getToken = prefs.getString('Token');

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
      if (imagePath != null) {
        final image = await http.MultipartFile.fromPath('image', imagePath);
        request.files.add(image);
      }

      // Send request and get response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Parse response body
      final result = jsonDecode(response.body) as Map<String, dynamic>;

      // Check status code
      if (streamedResponse.statusCode == 200) {
        print('Account updated successfully');
      } else {
        print('Failed to update account: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error updating account: $e');
    }
  }
}
