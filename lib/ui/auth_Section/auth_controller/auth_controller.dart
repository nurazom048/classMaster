// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_req/auth_req.dart';
import 'package:table/ui/bottom_items/bottom_nevbar.dart';
import '../../../core/dialogs/alart_dialogs.dart';
import '../auth_ui/email_varification.screen.dart';
import '../auth_ui/logIn_screen.dart';

final authController_provider = StateNotifierProvider.autoDispose(
    (ref) => AuthController(ref.watch(authReqProvider)));

//

class AuthController extends StateNotifier<bool> {
  final AuthReq authReqq;
  AuthController(this.authReqq) : super(false);

  //

//******** createAccount      ************ */
  void createAccount({
    required BuildContext context,
    required String name,
    required String username,
    required String password,
    required String email,
  }) async {
    state = true;
    // responce
    Either<Message, Message> res = await AuthReq.createAccount(
      context,
      name: name,
      username: username,
      password: password,
      email: email,
    );

    res.fold((l) async {
      state = false;
      await FirebaseAuth.instance.currentUser!.delete();
      return Alart.showSnackBar(context, l.message);
    }, (r) {
      state = false;
      return Alart.showSnackBar(context, r.message);
    });
  }

//******** siginIn      ************ */
  siginIn(username, password, context) async {
    state = true;
    final res = await authReqq.login(username: username, password: password);

    res.fold(
      (l) async {
        state = false;
        print('***********************************${l.message} ${password}**');
        if (l.message.toString() == 'Email is not verified' &&
            l.email != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: l.email!,
            password: password,
          );
          Get.to(() => EmailVerificationScreen(
                email: l.email!,
                password: password,
              ));
          Alart.showSnackBar(context, 'Email is not varified');
        } else {
          print(l);
          return Alart.errorAlartDilog(context, l.message);
        }
      },
      (r) {
        state = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        Alart.showSnackBar(context, r);
      },
    );
  }

//******** changepassword  ************ */
  void changepassword(oldPassword, newPassword, context) async {
    state = true;
    final res = await authReqq.changePassword(oldPassword, newPassword);

    res.fold(
      (l) async {
        state = false;
        await FirebaseAuth.instance.currentUser!.delete();
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        state = false;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LogingScreen(),
          ),
        );

        Alart.showSnackBar(context, r.message);
      },
    );
  }

//******** forotpasswprd  ************ */

  void forgotPassword(newPassword, context,
      {String? email, String? phone}) async {
    state = true;
    final res =
        await authReqq.forgrtPassword(newPassword, email: email, phone: phone);

    res.fold(
      (l) {
        state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        state = false;

        Alart.showSnackBar(context, r.message);
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
  static Future<void> logOut(context) async {
    Alart.errorAlertDialogCallBack(
      context,
      "Are You Sure To logout ?",
      onConfirm: (bool confirmed) async {
        if (confirmed) {
          // Remove token and navigate to the login screen
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('Token');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LogingScreen()));
        }
      },
    );
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
}
