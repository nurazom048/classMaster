// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local data/local_data.dart';

class RouterHelper {
  static Future<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    final String? token = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();

    print("Token: $token  refreshToken: $refreshToken");
    print("Current location: ${state.location}");

    // ✅ If the user is authenticated, allow them to access protected routes
    if (token != null && refreshToken != null) {
      if (state.subloc == '/') {
        print('Redirecting authenticated user to /home');
        return '/home';
      }
      return null; // Allow navigation for authenticated users
    }

    // ✅ Prevent infinite loop: Do NOT redirect if already on the login page
    if (state.subloc == '/auth/login') {
      print('Already on login screen, no redirect needed.');
      return null;
    }

    // 🚀 Fix: Redirect only from Splash or unknown routes to Login
    if (state.subloc == '/') {
      print('Redirecting unauthenticated user to /auth/login');
      return '/auth/login';
    }

    return null; // Allow access for other non-protected routes
  }
}
