// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_data/local_data.dart';

class RouterHelper {
  // ✅ Optional: Cache auth state for 5 seconds to reduce repeated calls
  static DateTime? _lastCacheTime;
  static String? _cachedToken;
  static String? _cachedRefreshToken;
  static bool? _cachedIsGuest;
  static const Duration _cacheDuration = Duration(seconds: 5);

  static Future<Map<String, dynamic>> _getAuthData() async {
    // Check if cache is still valid
    if (_lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheDuration) {
      print('🔄 Using cached auth data');
      return {
        'token': _cachedToken,
        'refreshToken': _cachedRefreshToken,
        'isGuest': _cachedIsGuest,
      };
    }

    // Fetch fresh data
    final results = await Future.wait([
      LocalData.getAuthToken(),
      LocalData.getRefreshToken(),
      LocalData.isGuest(),
    ]);

    // Update cache
    _cachedToken = results[0] as String?;
    _cachedRefreshToken = results[1] as String?;
    _cachedIsGuest = results[2] as bool;
    _lastCacheTime = DateTime.now();

    return {
      'token': _cachedToken,
      'refreshToken': _cachedRefreshToken,
      'isGuest': _cachedIsGuest,
    };
  }

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

    // ===== PUBLIC ROUTES (No auth check needed) =====
    // Add any other public routes here
    // if (state.subloc.startsWith('/public/')) {
    //   return null;
    // }

    // 🚀 Get auth data (with optional caching)
    final authData = await _getAuthData();
    final String? token = authData['token'] as String?;
    final String? refreshToken = authData['refreshToken'] as String?;
    final bool isGuest = authData['isGuest'] as bool;

    print("Token: $token  refreshToken: $refreshToken  isGuest: $isGuest");
    print("Current location: ${state.subloc}");

    final bool isAuthenticated = token != null && refreshToken != null;
    final bool isAuthRoute = state.subloc.startsWith('/auth/');

    // ❌ Unauthenticated + Not Guest → Redirect to Login
    if (!isAuthenticated && !isGuest) {
      if (!isAuthRoute) {
        print('Redirecting unauthenticated user to /auth/login');
        return '/auth/login';
      }
      return null;
    }

    // ✅ Authenticated or Guest: Redirect away from splash ('/') or any auth route (including login) to home
    if (state.subloc == '/' || isAuthRoute) {
      print('Redirecting authenticated/guest user from ${state.subloc} to /home');
      return '/home';
    }

    return null;
  }

  // ✅ Clear cache when needed (e.g., on logout)
  static void clearCache() {
    _lastCacheTime = null;
    _cachedToken = null;
    _cachedRefreshToken = null;
    _cachedIsGuest = null;
    print('🗑️ Auth cache cleared');
  }
}
