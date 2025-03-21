// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, void_checks, avoid_print, unnecessary_null_comparison

import 'package:classmate/core/constant/constant.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/email_verification.screen.dart';
import 'package:classmate/features/notice_fetures/presentation/utils/pdf_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:classmate/core/local%20data/local_data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/message_model.dart';
import '../../../../route/route_constant.dart';
import '../../../../ui/bottom_navbar.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../../../wellcome_splash/presentation/screen/pending_account.dart';
import '../../data/datasources/auth_req.dart';
import '../../presentation/screen/LogIn_Screen.dart';

final authController_provider =
    StateNotifierProvider.autoDispose<AuthController, bool>(
        (ref) => AuthController(ref.watch(authReqProvider)));

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
    String? eiinNumber,
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
      eiinNumber: eiinNumber,
      contractInfo: contractInfo,
    );

    res.fold((l) async {
      state = false;
      return Alert.showSnackBar(context, l.message);
    }, (r) async {
      state = false;

      // Delete signup info from Hive
      var signUpInfoHive = Hive.box('signUpInfo');
      await signUpInfoHive.clear(); // Clears all stored signup data
      print("Signup data deleted from Hive");

      // Navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            emailAddress: username.isNotEmpty ? email : null,
            passwordAddress: password,
            usernameAddress: username,
          ),
        ),
      );
      return Alert.showSnackBar(context, r.message);
    });
  }

//******** signIn      ************ */
  Future<void> signIn(
    context, {
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
    }

    // print('Username $username || emails$email');
    else if ((username == null || username == '') &&
        (email == null || email == '')) {
      Alert.errorAlertDialog(
        context,
        "email or username is required",
      );
    } else {
      state = true;
      final res = await authReq.login(
        username: email != null ? null : username,
        email: email,
        password: password,
      );

      res.fold(
        (error) async {
          state = false;

          if (error.message == 'Academy request is pending') {
            Get.to(() => const PendingScreen());
          }
          if (error.message == 'Email is not verified') {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: error.email!,
              password: password,
            );
            Get.to(() => EmailVerificationScreen(
                  email: error.email!,
                  password: password,
                ));
            Alert.showSnackBar(context, 'Email is not verified');
          } else {
            return Alert.errorAlertDialog(context, error.message);
          }
        },
        (data) {
          state = false;
          // land to the Home screen
          GoRouter.of(context).pushNamed(RouteConst.home);
          Alert.showSnackBar(context, data);
          Alert.showSnackBar(context, data);
        },
      );
    }
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
        await FirebaseAuth.instance.signOut();
        // Remove token and navigate to the login screen
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('Token');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );

        Alert.showSnackBar(context, r.message);
      },
    );
  }

//******** forotpasswprd  ************ */

  void forgotPassword(context,
      {String? email, String? username, String? phone}) async {
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
  static Future<void> logOut(BuildContext context,
      {required WidgetRef ref}) async {
    Alert.errorAlertDialogCallBack(
      context,
      "Are You Sure To logout?",
      onConfirm: () async {
        try {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseAuth.instance.signOut();
          }

          // Clear local data
          await LocalData.emptyLocal();
          await PdfUtils.clearPdfCache(); // Clear cache on logout
          // Ensure navigation happens only if the context is still valid
          if (!context.mounted) return;

          // 🚀 Replace navigation stack (User cannot go back)
          GoRouter.of(context).goNamed(RouteConst.login);
        } catch (e) {
          print(e);
          Alert.errorAlertDialog(context, '$e');
        }
      },
    );
  }

  //*********************************************************** */
  Future<void> continueWithGoogle(
    context, {
    required String googleAuthToken,
    String? accountType,
    String? eiinNumber,
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
        eiinNumber: eiinNumber,
        contractInfo: contractInfo,
      );

      res.fold(
        (error) async {
          state = false;
          if (error.message == 'Academy request is pending') {
            Get.to(() => const PendingScreen());
          } else {
            return Alert.errorAlertDialog(context, error.message);
          }
        },
        (data) async {
          state = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
          Alert.showSnackBar(context, data);
        },
      );
    }
  }
}
