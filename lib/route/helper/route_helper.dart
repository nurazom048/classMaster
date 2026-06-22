// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_data/local_data.dart';

class RouterHelper {
  static Future<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    final String? token = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();
    final bool isGuest = await LocalData.isGuest();

    print("Token: $token  refreshToken: $refreshToken  isGuest: $isGuest");
    print("Current location: ${state.location}");

    final bool isAuthenticated = token != null && refreshToken != null;
    final bool isAuthRoute = state.subloc.startsWith('/auth/');

    // 1. If not authenticated and not a guest, they must go to/stay on auth routes
    if (!isAuthenticated && !isGuest) {
      if (!isAuthRoute) {
        print('Redirecting unauthenticated/non-guest user to /auth/login');
        return '/auth/login';
      }
      return null;
    }

    // 2. If authenticated or guest, and they are at root '/' or auth routes, redirect to home
    if (state.subloc == '/' || (isAuthRoute && state.subloc != '/auth/login')) {
      print('Redirecting to /home');
      return '/home';
    }

    return null; // Allow navigation
  }
}
