import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAccount {
  final String id; // Unique key (username or email)
  final String? username;
  final String? email;
  final String? name;
  final String? imageUrl;
  final String password;
  final String? accountType;
  final DateTime lastLoggedIn;

  SavedAccount({
    required this.id,
    this.username,
    this.email,
    this.name,
    this.imageUrl,
    required this.password,
    this.accountType,
    required this.lastLoggedIn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'name': name,
        'imageUrl': imageUrl,
        'password': password,
        'accountType': accountType,
        'lastLoggedIn': lastLoggedIn.toIso8601String(),
      };

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
        id: json['id'] ?? json['username'] ?? json['email'] ?? '',
        username: json['username'],
        email: json['email'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        password: json['password'] ?? '',
        accountType: json['accountType'],
        lastLoggedIn: json['lastLoggedIn'] != null
            ? DateTime.parse(json['lastLoggedIn'])
            : DateTime.now(),
      );
}

class SavedAccountsService {
  static const String _key = 'saved_accounts_list';

  static Future<List<SavedAccount>> getSavedAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_key);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final accounts = jsonList
          .map((item) => SavedAccount.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      // Sort by most recently logged in first
      accounts.sort((a, b) => b.lastLoggedIn.compareTo(a.lastLoggedIn));
      return accounts;
    } catch (e) {
      debugPrint('Error getting saved accounts: $e');
      return [];
    }
  }

  static Future<void> saveAccount({
    String? username,
    String? email,
    String? name,
    String? imageUrl,
    required String password,
    String? accountType,
  }) async {
    try {
      final String id = (username != null && username.isNotEmpty)
          ? username
          : (email ?? '');
      if (id.isEmpty) return;

      final accounts = await getSavedAccounts();
      final existingIndex = accounts.indexWhere(
          (acc) => acc.id.toLowerCase() == id.toLowerCase());

      final updatedAccount = SavedAccount(
        id: id,
        username: username ?? (existingIndex != -1 ? accounts[existingIndex].username : null),
        email: email ?? (existingIndex != -1 ? accounts[existingIndex].email : null),
        name: name ?? (existingIndex != -1 ? accounts[existingIndex].name : null),
        imageUrl: imageUrl ?? (existingIndex != -1 ? accounts[existingIndex].imageUrl : null),
        password: password,
        accountType: accountType ?? (existingIndex != -1 ? accounts[existingIndex].accountType : null),
        lastLoggedIn: DateTime.now(),
      );

      if (existingIndex != -1) {
        accounts[existingIndex] = updatedAccount;
      } else {
        accounts.add(updatedAccount);
      }

      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(accounts.map((a) => a.toJson()).toList());
      await prefs.setString(_key, jsonString);
    } catch (e) {
      debugPrint('Error saving account: $e');
    }
  }

  static Future<void> removeAccount(String id) async {
    try {
      final accounts = await getSavedAccounts();
      accounts.removeWhere((acc) => acc.id.toLowerCase() == id.toLowerCase());

      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(accounts.map((a) => a.toJson()).toList());
      await prefs.setString(_key, jsonString);
    } catch (e) {
      debugPrint('Error removing account: $e');
    }
  }
}
