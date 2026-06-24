// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_data/local_data.dart';

class RouterHelper {
  static Future<String?> handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    print("REDIRECT CHECK => ${state.subloc}");

    // ===== PUBLIC NOTICE ROUTE =====
    if (state.subloc.startsWith('/notice/')) {
      print("PUBLIC NOTICE ROUTE ALLOWED");
      return null;
    }

    final String? token = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();
    final bool isGuest = await LocalData.isGuest();

    print("Token: $token  refreshToken: $refreshToken  isGuest: $isGuest");
    print("Current location: ${state.subloc}");

    final bool isAuthenticated = token != null && refreshToken != null;

    final bool isAuthRoute = state.subloc.startsWith('/auth/');

    if (!isAuthenticated && !isGuest) {
      if (!isAuthRoute) {
        print('Redirecting unauthenticated user to /auth/login');
        return '/auth/login';
      }
      return null;
    }

    if (state.subloc == '/' || (isAuthRoute && state.subloc != '/auth/login')) {
      print('Redirecting to /home');
      return '/home';
    }

    return null;
  }
}
