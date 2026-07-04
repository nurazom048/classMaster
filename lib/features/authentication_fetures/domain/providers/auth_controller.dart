// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, void_checks, avoid_print, unnecessary_null_comparison

import 'package:classmate/core/constant/constant.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/email_verification.screen.dart';
import 'package:classmate/features/notice_fetures/presentation/utils/pdf_utils.dart';
import 'package:classmate/ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:classmate/core/local_data/local_data.dart';
import 'package:classmate/route/helper/route_helper.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/message_model.dart';
import '../../../../route/route_constant.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../../../welcome_splash/presentation/screen/pending_account.dart'
    show PendingScreen;
import '../../data/datasources/auth_req.dart';
import '../../data/services/credential_save_service.dart';
import '../../presentation/screen/login_screen.dart';

final authController_provider =
    StateNotifierProvider.autoDispose<AuthController, bool>(
      (ref) => AuthController(ref.watch(authReqProvider)),
    );

//

class AuthController extends StateNotifier<bool> {
  final AuthReq authReq;
  AuthController(this.authReq) : super(false);

  //

  //******** createAccount      ************ */
  createAccount({
    required BuildContext context,
    required String name,
    required String username,
    required String password,
    required String email,
    required String accountType,
    String? contractInfo,
  }) async {
    state = true;
    // response
    Either<Message, Message> res = await AuthReq.createAccount(
      context,
      name: name,
      username: username,
      password: password,
      email: email,
      accountType: accountType,
      contractInfo: contractInfo,
    );

    res.fold(
      (l) async {
        state = false;
        return Alert.showSnackBar(context, l.message);
      },
      (r) async {
        state = false;

        // Navigate to Login Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(
                // emailAddress: username.isNotEmpty ? email : null,
                //passwordAddress: password,
                //usernameAddress: username,
              );
            },
          ),
        );
        return Alert.showSnackBar(context, r.message);
      },
    );
  }

  //******** signIn      ************ */
  Future<void> signIn(
    BuildContext context, {
    String? username,
    String? email,
    required String password,
  }) async {
    final bool isOnline = await Utils.isOnlineMethod();

    if (!isOnline) {
      Alert.errorAlertDialog(
        context,
        'You are in Offline',
        title: 'Network Error',
      );
      return; // Added return to prevent continuing on error
    }

    if ((username == null || username == '') &&
        (email == null || email == '')) {
      Alert.errorAlertDialog(context, "email or username is required");
      return; // Added return to prevent continuing on error
    }

    state = true;
    final res = await authReq.login(
      username: email == null || email == '' ? username : null,
      email: email,
      password: password,
    );

    res.fold(
      (error) async {
        state = false;

        if (error.message == 'Academy request is pending') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PendingScreen()),
          );
          return;
        }
        if (error.message == 'Email is not verified') {
          if (!context.mounted) return;
          // go to email verification screen
          context.pushNamed(RouteConst.verifiedEmail, extra: error.email);
          Alert.showSnackBar(context, 'Email is not verified');
        } else {
          if (!context.mounted) return;
          Alert.errorAlertDialog(context, error.message);
        }
      },
      (dynamic data) async {
        state = false;

        // Trigger browser / Google password manager saving
        try {
          TextInput.finishAutofillContext();
        } catch (e) {
          debugPrint('Failed to finish autofill context: $e');
        }

        // 1. Wrap in try/catch! If the credential prompt is dismissed or fails,
        // it won't crash the code and stop the routing process.
        try {
          final isUsername = email == null || email == '';
          await CredentialSaveService.saveCredentials(
            context: context,
            username: isUsername ? username : null,
            email: !isUsername ? email : null,
            password: password,
            isUsername: isUsername,
          );
        } catch (e) {
          debugPrint('Credential save skipped or failed: $e');
        }

        // 2. Ensure widget is still mounted before routing
        if (!context.mounted) return;

        // Clear redirect cache so RouterHelper gets fresh data
        RouterHelper.clearCache();

        // 3. Land to the Home screen FIRST
        context.goNamed(RouteConst.home);

        // 4. Safely extract the message for the SnackBar.
        // Your console shows `data` is an Object/Map, not a raw String!
        String successMsg = "Login Successful";
        if (data is Map && data['message'] != null) {
          successMsg = data['message'].toString();
        } else if (data != null) {
          try {
            successMsg = (data as dynamic).message ?? successMsg;
          } catch (_) {}
        }

        Alert.showSnackBar(context, successMsg);
      },
    );
  }

  //******** change password  ************ */
  void changepassword(oldPassword, newPassword, context) async {
    state = true;
    final res = await authReq.changePassword(oldPassword, newPassword);
    res.fold(
      (l) async {
        state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) async {
        state = false;
        try {
          await FirebaseAuth.instance.signOut();
        } catch (_) {}
        await LocalData.emptyLocal();
        RouterHelper.clearCache();
        if (context.mounted) {
          context.goNamed(RouteConst.login);
          Alert.showSnackBar(context, r.message);
        }
      },
    );
  }

  //******** forgotPassword  ************ */

  void forgotPassword(
    context, {
    String? email,
    String? username,
    String? phone,
  }) async {
    state = true;
    final res = await authReq.forgetPassword(email: email, phone: phone);

    res.fold(
      (l) {
        state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) async {
        try {
          //  await FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword)
          await FirebaseAuth.instance.sendPasswordResetEmail(email: r.email!);
          state = false;

          return Alert.upcoming(
            context,
            header: 'Success',
            message: FORGOT_MAIL_SEND_MESSAGE,
          );
        } on FirebaseAuthException catch (e) {
          Alert.handleError(context, e);
        }

        Alert.showSnackBar(context, r.message);
      },
    );
  }

  //******** logout  ************ */
  static Future<void> logOut(
    BuildContext context, {
    required WidgetRef ref,
  }) async {
    Alert.errorAlertDialogCallBack(
      context,
      "Are You Sure To logout?",
      onConfirm: (isConfirmed) async {
        if (isConfirmed) {
          try {
            // 2. Sign out from Firebase if user session exists
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseAuth.instance.signOut();
            }

            // 3. Clear all stored local data, PDF cache, and Router cache
            await LocalData.emptyLocal();
            await PdfUtils.clearPdfCache();
            RouterHelper.clearCache();

            // 4. Give GoRouter a moment for the dialog animation to finish closing (Prevents race conditions)
            await Future.delayed(const Duration(milliseconds: 100));

            // 5. Check if the context is still mounted, then navigate to the login screen
            if (!context.mounted) return;
            context.goNamed(RouteConst.login);
          } catch (e) {
            print('Logout error: $e');
            if (context.mounted) {
              Alert.errorAlertDialog(context, '$e');
            }
          }
        }
      },
    );
  }

  //*********************************************************** */
  Future<void> continueWithGoogle(
    context, {
    required String googleAuthToken,
    String? accountType,
    String? contractInfo,
  }) async {
    final bool isOnline = await Utils.isOnlineMethod();

    if (!isOnline) {
      Alert.errorAlertDialog(
        context,
        'You are in Offline',
        title: 'Network Error',
      );
    } else {
      state = true;
      final Either<Message, String> res = await authReq.continueWithGoogle(
        googleAuthToken: googleAuthToken,
        accountType: accountType,
        contractInfo: contractInfo,
      );

      res.fold(
        (error) async {
          state = false;
          if (error.message == 'Academy request is pending') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PendingScreen()),
            );
          } else {
            return Alert.errorAlertDialog(context, error.message);
          }
        },
        (data) async {
          state = false;
          RouterHelper.clearCache();
          if (context.mounted) {
            context.goNamed(RouteConst.home);
            Alert.showSnackBar(context, data);
          }
        },
      );
    }
  }
}
