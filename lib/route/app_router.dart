import 'package:classmate/features/authentication_fetures/presentation/screen/LogIn_Screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/SignUp_Screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/forgetpassword_screen.dart';
import 'package:classmate/features/wellcome_splash/presentation/screen/splash_screen.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/local data/local_data.dart';
import '../ui/bottom_navbar.dart';

class AppRouters {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/home',
        name: RouteConst.home,
        pageBuilder: (context, state) => MaterialPage(
          child: BottomNavBar(),
        ),
      ),

      // auth
      GoRoute(
        path: '/auth/login',
        name: RouteConst.login,
        pageBuilder: (context, state) =>
            const MaterialPage(child: LoginScreen()),
      ),

      GoRoute(
        name: RouteConst.signUp,
        path: '/auth/sign_up',
        pageBuilder: (context, state) => MaterialPage(
          child: SignUpScreen(
            emailAddress: state.extra as String?,
          ),
        ),
      ),
      GoRoute(
        path: '/auth/forget_password',
        name: RouteConst.forgetPassword,
        pageBuilder: (context, state) {
          final email = state.extra as String?; // Default to an empty string
          return MaterialPage(
            child: ForgetPasswordScreen(email: email),
          );
        },
      ),

      GoRoute(
        path: '/collections',
        pageBuilder: (context, state) => MaterialPage(
          child: SignUpScreen(
            emailAddress: state.params["email"],
          ),
        ),
      ),
      GoRoute(
        path: '/error',
        pageBuilder: (context, state) => const MaterialPage(
          child: Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        ),
      ),
    ],
    redirect: (context, state) async {
      final String? token = await LocalData.getAuthToken();
      final String? refreshToken = await LocalData.getRefreshToken();

      // Log the token for debugging
      print("Token: $token  refreshToken: $refreshToken");

      // If both tokens exist, redirect to home
      if (token != null && refreshToken != null) {
        return '/home';
      }

      // Otherwise, stay at the current location or redirect to login
      if (state.location == '/') {
        return '/auth/login';
      }

      return null; // No redirect
    },
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Error: ${state.error}')),
      ),
    ),
  );
}
