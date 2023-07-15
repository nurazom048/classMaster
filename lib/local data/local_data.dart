// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
// ShaSharedPreferences

  //****** Auth And Refresh Token****** */
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // Get header
  static Future<Map<String, String>> getHerder() async {
    final String? authToken = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();

    //
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'x-refresh-token': "$refreshToken",
    };

    return headers;
  }

  // Get header
  static Future<void> setHerder(response) async {
    final String? currentAuthToken = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();

    //
    final authToken = response.headers?['authorization'];
    final newRefreshToken = response.headers?['x-refresh-token'];
    //
    if (authToken != currentAuthToken && authToken != null) {
      await LocalData.saveAuthToken(authToken);
    }

    if (refreshToken != newRefreshToken && newRefreshToken != null) {
      print('NewRefreshToken saved......................');

      await LocalData.saveRefreshToken(newRefreshToken);
    }
  }
}
