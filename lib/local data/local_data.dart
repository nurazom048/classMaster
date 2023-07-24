import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  // const String
  static const String _accountType = "AccountType";
  static const String _username = "'username'";
  static const String _authToken = "authToken";
  static const String _refreshToken = "refreshToken";

//************************************************************************************* */
//
//................ save Auth and refresh token header....................................//
//
//*************************************************************************************** */

  // Auth And Refresh Token
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authToken, token);
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authToken);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshToken);
  }

  // Get header
  static Future<Map<String, String>> getHerder() async {
    final String? authTokenn = await LocalData.getAuthToken();
    final String? refreshTokenn = await LocalData.getRefreshToken();

    //
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authTokenn',
      'x-refresh-token': "$refreshTokenn",
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
      // ignore: avoid_print
      print('NewRefreshToken saved......................');

      await LocalData.saveRefreshToken(newRefreshToken);
    }
  }

//
//****************************************************************** */
//
//................ Save localData.....................................//
//
//****************************************************************** */

// save and get account Type

  static Future<String?> getAccountType() async {
    final prefs = await SharedPreferences.getInstance();
    final String? type = prefs.getString(_accountType);
    return type;
  }

// save account Type
  static Future<void> saveAccountType(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountType, token);
  }

//******************* save and get username  ************************** */
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final String? type = prefs.getString(_username);
    return type;
  }
// save account Type

  static Future<void> saveUsername(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_username, token);
  }

//****************************************************************** */
//
//................ remove data localData.............................//
//
//****************************************************************** */

  static Future<void> emptyLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_authToken);
    prefs.remove(_refreshToken);
    prefs.remove(_accountType);
    prefs.remove(_username);
  }
}
