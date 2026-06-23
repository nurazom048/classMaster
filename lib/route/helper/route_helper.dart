// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/local_data/local_data.dart';

class RouterHelper {
  static Future<String?> handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final String? token = await LocalData.getAuthToken();
    final String? refreshToken = await LocalData.getRefreshToken();
    final bool isGuest = await LocalData.isGuest();

    print("Token: $token  refreshToken: $refreshToken  isGuest: $isGuest");
    print("Current location: ${state.subloc}");

    final bool isAuthenticated = token != null && refreshToken != null;
    final bool isAuthRoute = state.subloc.startsWith('/auth/');

    // 🔥 নতুন কন্ডিশন: ইউজার নোটিশ দেখতে চাচ্ছে কিনা চেক করা
    final bool isNoticeRoute = state.subloc.startsWith('/notice/');

    // ১. ইউজার যদি লগইন না থাকে এবং গেস্টও না হয়
    if (!isAuthenticated && !isGuest) {
      // অথ রুট এবং নোটিশ রুট বাদে অন্য যেকোনো পেজে যেতে চাইলে তাকে লগইন পেজে পাঠাও
      // (যাতে শেয়ার করা নোটিশের লিংকে ক্লিক করলে লগইন ছাড়াও নোটিশ দেখা যায়)
      if (!isAuthRoute && !isNoticeRoute) {
        print('Redirecting unauthenticated user to /auth/login');
        return '/auth/login';
      }
      return null;
    }

    // ২. যদি লগইন বা গেস্ট ইউজার ভুল করে রুট '/' বা অথ রুটে চলে যায়, তাকে হোমে পাঠাও
    if (state.subloc == '/' || (isAuthRoute && state.subloc != '/auth/login')) {
      print('Redirecting to /home');
      return '/home';
    }

    // বাকি সব রুটের জন্য (যেমন: /notice/:id) নরমাল ন্যাভিগেশন অ্যালাউ করো
    return null;
  }
}
