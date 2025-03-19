import 'package:hive/hive.dart';

class LocalData {
  static const String _authBox = 'authBox';
  static const String _accountType = "AccountType";
  static const String _username = "username";
  static const String _authToken = "authToken";
  static const String _refreshToken = "refreshToken";

//***********************************************************************************///
//................ save Auth and refresh token header.................................//
//*********************************************************************************** */

  // Open the Hive box
  static Future<Box> _openBox() async {
    return await Hive.openBox(_authBox);
  }

  // Save Auth Token
  static Future<void> saveAuthToken(String token) async {
    var box = await Hive.openBox('authBox');
    box.put('authToken', token);
  }

  static Future<String?> getAuthToken() async {
    var box = await Hive.openBox('authBox');
    return box.get('authToken');
  }

  // Save Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    final box = await _openBox();
    await box.put(_refreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    final box = await _openBox();
    return box.get(_refreshToken);
  }

  // Get header
  static Future<Map<String, String>> getHeader() async {
    final String? authToken = await getAuthToken();
    final String? refreshToken = await getRefreshToken();
    return {
      'Authorization': 'Bearer $authToken',
      'x-refresh-token': refreshToken ?? '',
    };
  }

  static Future<void> setHerder(response) async {
    final authToken = response.headers?['authorization'] as String?;
    final newRefreshToken = response.headers?['x-refresh-token'] as String?;

    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
      print('New RefreshToken saved');
      await LocalData.saveRefreshToken(newRefreshToken);
    }
  }

  // Save and Get Account Type
  static Future<void> saveAccountType(String type) async {
    final box = await _openBox();
    await box.put(_accountType, type);
  }

  static Future<String?> getAccountType() async {
    final box = await _openBox();
    return box.get(_accountType);
  }

  // Save and Get Username
  static Future<void> saveUsername(String username) async {
    final box = await _openBox();
    await box.put(_username, username);
  }

  static Future<String?> getUsername() async {
    final box = await _openBox();
    return box.get(_username);
  }

  // Clear All Stored Data
  static Future<void> emptyLocal() async {
    final box = await _openBox();
    await box.clear();
  }
}
