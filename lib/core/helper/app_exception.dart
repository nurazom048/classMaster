import 'package:flutter/foundation.dart';

class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() {
    if (kDebugMode) {
      print('AppException: $message');
    }
    return 'AppException: $message';
  }
}
