import 'package:flutter/services.dart';

class AndroidCredentialManager {
  static const platform = MethodChannel('com.classmate.app/credentials');

  static Future<void> saveCredentials({
    required String id,
    required String username,
    required String password,
  }) async {
    try {
      await platform.invokeMethod('saveCredentials', {
        'id': id,
        'username': username,
        'password': password,
      });
    } on PlatformException catch (e) {
      print("Failed to save credentials: ${e.message}");
    }
  }

  static Future<Map<String, String>?> getCredentials(String id) async {
    try {
      final result = await platform.invokeMethod('getCredentials', {'id': id});
      if (result != null) {
        return Map<String, String>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      print("Failed to get credentials: ${e.message}");
      return null;
    }
  }

  static Future<void> deleteCredentials(String id) async {
    try {
      await platform.invokeMethod('deleteCredentials', {'id': id});
    } on PlatformException catch (e) {
      print("Failed to delete credentials: ${e.message}");
    }
  }
}
