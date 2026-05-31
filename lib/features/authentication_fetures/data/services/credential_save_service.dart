import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'android_credential_manager.dart';

class CredentialSaveService {
  static Future<void> saveCredentials({
    required BuildContext context,
    String? username,
    String? email,
    required String password,
    required bool isUsername,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Save Credentials?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you want to save your credentials for faster login?'),
              const SizedBox(height: 16),
              if (isUsername && username != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (!isUsername && email != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Not Now'),
            ),
            FilledButton(
              onPressed: () async {
                await _saveCredentialsLocally(
                  username: username,
                  email: email,
                  password: password,
                  isUsername: isUsername,
                );

                if (!kIsWeb && !kDebugMode) {
                  await _saveToAndroidCredentialManager(
                    username: username,
                    email: email,
                    password: password,
                    isUsername: isUsername,
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _saveCredentialsLocally({
    String? username,
    String? email,
    required String password,
    required bool isUsername,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (isUsername && username != null) {
        await prefs.setString('saved_username', username);
      } else if (!isUsername && email != null) {
        await prefs.setString('saved_email', email);
      }
      await prefs.setString('saved_password', password);
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  static Future<void> _saveToAndroidCredentialManager({
    String? username,
    String? email,
    required String password,
    required bool isUsername,
  }) async {
    try {
      final credential = isUsername ? username : email;
      if (credential != null) {
        await AndroidCredentialManager.saveCredentials(
          id: 'classmate_login',
          username: credential,
          password: password,
        );
      }
    } catch (e) {
      print('Error saving to Android Credential Manager: $e');
    }
  }

  static Future<Map<String, String?>> getSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var credentials = {
        'username': prefs.getString('saved_username'),
        'email': prefs.getString('saved_email'),
        'password': prefs.getString('saved_password'),
      };

      if (!kIsWeb && credentials['password'] == null) {
        final androidCreds =
            await AndroidCredentialManager.getCredentials('classmate_login');
        if (androidCreds != null) {
          credentials['username'] = androidCreds['username'];
          credentials['password'] = androidCreds['password'];
        }
      }

      return credentials;
    } catch (e) {
      print('Error retrieving credentials: $e');
      return {};
    }
  }

  static Future<void> clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_username');
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');

      if (!kIsWeb) {
        await AndroidCredentialManager.deleteCredentials('classmate_login');
      }
    } catch (e) {
      print('Error clearing credentials: $e');
    }
  }
}

