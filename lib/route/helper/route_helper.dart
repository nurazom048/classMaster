// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local data/local_data.dart';

class RouterHelper {
  static Future<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    final String? token = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();

    // Log tokens and current location for debugging
    print("Token: $token  refreshToken: $refreshToken");
    print("Current location: ${state.location}");

    if (token != null && refreshToken != null) {
      if (state.subloc == '/') {
        print('Redirecting authenticated user to /home');
        return '/home'; // Redirect authenticated users to home
      }
      // Allow navigation for authenticated users
      return null;
    }

    // If user is unauthenticated, redirect protected routes to login
    if (state.location.startsWith('/routine') ||
        state.location.startsWith('/home')) {
      print('Redirecting unauthenticated user to /auth/login');
      return '/auth/login';
    }

    // Allow access for non-protected routes
    return null;
  }
}
