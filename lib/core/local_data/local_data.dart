import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class LocalData {
  static const String _authBox = 'authBox';
  static const String _accountType = "AccountType";
  static const String _username = "username";
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
    box.put('isGuest', false);
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

  // Guest Mode
  static Future<void> saveIsGuest(bool isGuest) async {
    final box = await _openBox();
    await box.put('isGuest', isGuest);
  }

  static Future<bool> isGuest() async {
    final box = await _openBox();
    return box.get('isGuest', defaultValue: false) == true;
  }

  // Get header
  static Future<Map<String, String>> getHeader() async {
    final String? authToken = await getAuthToken();
    final String? refreshToken = await getRefreshToken();
    final bool guest = await isGuest();

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $authToken',
      'x-refresh-token': refreshToken ?? '',
    };

    if (guest) {
      headers['X-App-Client'] = 'ClassMaster';
      headers['X-Guest'] = 'true';
    }

    return headers;
  }

  static Future<void> setHerder(response) async {
    final newRefreshToken = response.headers?['x-refresh-token'] as String?;

    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
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

final isGuestProvider = FutureProvider<bool>((ref) async {
  return LocalData.isGuest();
});
