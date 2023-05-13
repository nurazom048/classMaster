// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_req/auth_req.dart';
import 'package:table/ui/bottom_items/bottom_nev_bar.dart';
import '../../../core/dialogs/alart_dialogs.dart';

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
  }) async {
    state = true;
    // responce
    Either<String, Message> res = await AuthReq.createAccount(
      context,
      name: name,
      username: username,
      password: password,
    );

    res.fold((l) {
      state = false;
      return Alart.showSnackBar(context, l);
    }, (r) {
      state = false;

      return Alart.showSnackBar(context, r.message);
    });
  }

//******** siginIn      ************ */
  void siginIn(username, password, context) async {
    state = true;
    final res = await authReqq.login(username: username, password: password);

    res.fold(
      (l) {
        state = false;
        return Alart.errorAlartDilog(context, l);
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
}
