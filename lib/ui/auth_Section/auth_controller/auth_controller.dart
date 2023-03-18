// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_req/auth_req.dart';
import 'package:table/ui/bottom_items/bottm_nev_bar.dart';
import 'package:table/widgets/Alart.dart';

final authController_provider =
    Provider.autoDispose((ref) => AuthController(ref.read(auth_req_provider)));

class AuthController {
  final AuthReq authReqq;
  AuthController(this.authReqq);

  //
//******** siginIn      ************ */
  void siginIn(username, password, context) async {
    final res = await authReqq.login(username: username, password: password);

    res.fold(
      (l) => Alart.errorAlartDilog(context, l),
      (r) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNevBar()));
        Alart.showSnackBar(context, r);
      },
    );
  }
}
