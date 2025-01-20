import 'package:classmate/features/authentication_fetures/presentation/screen/LogIn_Screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/SignUp_Screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/forgetpassword_screen.dart';
import 'package:classmate/features/routine_Fetures/presentation/screens/add_class_screen.dart';
import 'package:classmate/features/wellcome_splash/presentation/screen/splash_screen.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/routine_Fetures/presentation/screens/create_new_rutine.dart';
import '../features/routine_Fetures/presentation/screens/view_more_screen.dart';
import '../features/search_fetures/presentation/screens/search_page.dart';
import '../ui/bottom_navbar.dart';
import 'helper/route_helper.dart';

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

      // routine routes
      ...[
        GoRoute(
          path: '/routine/create',
          name: RouteConst.createRoutine,
          pageBuilder: (context, state) => MaterialPage(
            child: CreateNewRoutine(),
          ),
        ),
        GoRoute(
          path: '/routine/:routineID/view',
          name: RouteConst.viewRoutine,
          pageBuilder: (context, state) => MaterialPage(
            child: ViewMore(
              routineId: state.params['routineID'] as String,
              routineName: state.extra as String,
            ),
          ),
        ),
        GoRoute(
          path: '/routine/:routineId/addclass',
          name: RouteConst.addClass,
          pageBuilder: (context, state) => MaterialPage(
            child: AddClassScreen(
              routineId: state.params["routineId"]!,
              isUpdate: state.extra as bool?,
            ),
          ),
        ),
      ],

      /// Search Routes
      ...[
        GoRoute(
          path: '/search',
          name: RouteConst.searchPage,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: const SearchPAge(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Start from the right
                  end: Offset.zero, // End at the current position
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
      ],

      // collections
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
      return await RouterHelper.handleRedirect(context, state);
    },
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Error: ${state.error}')),
      ),
    ),
  );
}
