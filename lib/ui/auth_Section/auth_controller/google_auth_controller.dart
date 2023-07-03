import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth_ui/logIn_screen.dart';

//! provider
final googleAuthControllerProvider =
    Provider<GooleAuthController>((ref) => GooleAuthController());

// class
class GooleAuthController extends ChangeNotifier {
  var gooleSiginIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  bool lodging = false;

  signin(context) async {
    lodging = true;
    // pick account and store into googleAccount variable
    GoogleSignInAccount? selectedGooleAccount = await gooleSiginIn.signIn();
    if (selectedGooleAccount == null) {
      lodging = false;
    }
    googleAccount = selectedGooleAccount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CredentialScreen(),
      ),
    );
    // ignore: avoid_print
    print(googleAccount);
    lodging = false;
    notifyListeners();
  }
}
