// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_req/auth_req.dart';
import 'package:table/ui/bottom_items/bottm_nev_bar.dart';
import '../../../core/dialogs/Alart_dialogs.dart';

final authController_provider = StateNotifierProvider.autoDispose(
    (ref) => AuthController(ref.watch(auth_req_provider)));

//

class AuthController extends StateNotifier<bool> {
  final AuthReq authReqq;
  AuthController(this.authReqq) : super(false);

  //
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNevBar()));
        Alart.showSnackBar(context, r);
      },
    );
  }
}
