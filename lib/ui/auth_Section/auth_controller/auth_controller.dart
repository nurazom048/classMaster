// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, void_checks

import 'dart:io';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_req/auth_req.dart';
import 'package:table/ui/bottom_items/Home/utils/utils.dart';
import 'package:table/ui/bottom_items/bottom_navbar.dart';
import '../../../constant/constant.dart';
import '../../../core/dialogs/alert_dialogs.dart';
import '../../../local data/api_cashe_maager.dart';
import '../auth_ui/email_verification.screen.dart';
import '../auth_ui/logIn_screen.dart';
import '../auth_ui/pending_account.dart';

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
    }, (r) {
      state = false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            emailAddress: email,
            passwordAddress: password,
            usernameAddress: username,
          ),
        ),
      );
      return Alert.showSnackBar(context, r.message);
    });
  }

//******** signIn      ************ */
  signIn(
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
        username: username,
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

  // get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    return getToken;
  }

// save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Token', token);
  }

  // remove remove
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('Token');
  }

  // LogOut
  static Future<void> logOut(context, {required WidgetRef ref}) async {
    Alert.errorAlertDialogCallBack(
      context,
      "Are You Sure To logout ?",
      onConfirm: () async {
        await FirebaseAuth.instance.signOut();

        // Remove token and navigate to the login screen
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('Token');
        await APICacheManager().emptyCache();

        // delete cash
        var appDir = (await getTemporaryDirectory()).path;
        Directory(appDir).delete();
        await MyApiCash.removeAll();
        //
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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

// get account Type

  static Future<String?> getAccountType() async {
    final prefs = await SharedPreferences.getInstance();
    final String? type = prefs.getString('AccountType');
    return type;
  }
// save account Type

  static Future<void> saveAccountType(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('AccountType', token);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final String? type = prefs.getString('username');
    return type;
  }
// save account Type

  static Future<void> saveUsername(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', token);
  }
}
