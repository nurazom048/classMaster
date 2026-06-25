import 'package:classmate/features/account_fetures/data/models/account_models.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/email_verification.screen.dart';
import 'package:classmate/features/collection_fetures/Ui/setting_screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/login_screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/signup_screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/forgetpassword_screen.dart';
import 'package:classmate/features/notice_fetures/data/models/recent_notice_model.dart';
import 'package:classmate/features/notice_fetures/presentation/screens/view_notice_screen.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/public_notice_screen.dart';
import 'package:classmate/features/routine_Fetures/presentation/screens/add_class_screen.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:classmate/ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/account_fetures/presentation/screens/edit_account.dart';
import '../features/routine_Fetures/presentation/screens/create_new_routine.dart';
import '../features/routine_Fetures/presentation/screens/view_more_screen.dart';
import '../features/search_fetures/presentation/screens/search_page.dart';
import '../features/welcome_splash/presentation/screen/splash_screen.dart';
import 'helper/route_helper.dart';

class AppRouters {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash and main routes
      GoRoute(
        path: '/',
        pageBuilder:
            (context, state) => const MaterialPage(child: SplashScreen()),
      ),
      GoRoute(
        path: '/home',
        name: RouteConst.home,
        pageBuilder: (context, state) => MaterialPage(child: BottomNavBar()),
      ),

      // Auth routes group
      GoRoute(
        path: '/auth/login',
        name: RouteConst.login,
        pageBuilder:
            (context, state) => const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/auth/sign_up',
        name: RouteConst.signUp,
        pageBuilder:
            (context, state) => MaterialPage(
              child: SignUpScreen(emailAddress: state.extra as String?),
            ),
      ),
      GoRoute(
        path: '/auth/forget_password',
        name: RouteConst.forgetPassword,
        pageBuilder:
            (context, state) => MaterialPage(
              child: ForgetPasswordScreen(email: state.extra as String?),
            ),
      ),
      GoRoute(
        path: '/auth/verifiedEmail',
        name: RouteConst.verifiedEmail,
        pageBuilder:
            (context, state) => MaterialPage(
              child: EmailVerificationScreen(email: state.extra as String),
            ),
      ),

      // Routine routes group
      GoRoute(
        path: '/routine/create',
        name: RouteConst.createRoutine,
        pageBuilder:
            (context, state) => MaterialPage(child: CreateNewRoutine()),
      ),
      GoRoute(
        path: '/routine/:routineID/view',
        name: RouteConst.viewRoutine,
        pageBuilder:
            (context, state) => MaterialPage(
              child: ViewMore(
                routineId: state.params['routineID']!,
                routineName: state.extra as String,
              ),
            ),
      ),
      GoRoute(
        path: '/routine/:routineId/addclass',
        name: RouteConst.addClass,
        pageBuilder:
            (context, state) => MaterialPage(
              child: AddClassScreen(
                routineId: state.params["routineId"]!,
                isUpdate: state.extra as bool?,
              ),
            ),
      ),

      // Search routes group
      GoRoute(
        path: '/search',
        name: RouteConst.searchPage,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              child: SearchPage(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
      ),

      // Account settings routes
      GoRoute(
        path: '/edit-account',
        name: RouteConst.editAccount,
        pageBuilder:
            (context, state) => const MaterialPage(child: EditAccount()),
      ),
      GoRoute(
        path: '/settings',
        name: RouteConst.settingsPage,
        pageBuilder: (context, state) => MaterialPage(child: SettingsPage()),
      ),

      GoRoute(
        path: '/notice/:id',
        name: RouteConst.viewNotice,
        pageBuilder: (context, state) {
          print("NOTICE ROUTE OPENED");
          print("Location = ${state.location}");

          // URL থেকে id
          final noticeId = state.params['id'];

          // Extra data (optional)
          final extraData = state.extra as ViewNoticeExtraData?;

          return CustomTransitionPage(
            child: NoticeViewScreen(
              noticeId: noticeId,
              notice: extraData?.notice,
              accountModel: extraData?.accountModel,
            ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
    redirect: (context, state) async {
      print("Current path: ${state.location}");
      return await RouterHelper.handleRedirect(context, state);
    },
    errorPageBuilder:
        (context, state) => MaterialPage(
          child: Scaffold(body: Center(child: Text('Error: ${state.error}'))),
        ),
  );
}
////
///

class ViewNoticeExtraData {
  final String? id;
  final Notice? notice;
  final AccountModels? accountModel;

  const ViewNoticeExtraData({this.id, this.notice, this.accountModel});
}
