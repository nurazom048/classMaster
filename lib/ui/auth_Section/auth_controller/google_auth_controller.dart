import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';

import '../../../core/dialogs/alert_dialogs.dart';
import '../auth_ui/cranditial_info_screen.dart';

//! provider
final googleAuthControllerProvider =
    Provider<GoogleAuthController>((ref) => GoogleAuthController());

// class
class GoogleAuthController extends ChangeNotifier {
  //
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  bool lodging = false;

  Future<void> signing(context, WidgetRef ref) async {
    lodging = true;
    // pick account and store into googleAccount variable
    GoogleSignInAccount? selectedGoogleAccount = await googleSignIn.signIn();
    if (selectedGoogleAccount == null) {
      lodging = false;
    }
    googleAccount = selectedGoogleAccount;

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CredentialScreen(),
    //   ),
    // );
////////////////////////

    if (googleAccount != null) {
      final GoogleSignInAccount? googleUser = googleAccount;

      final authentication = await googleUser?.authentication;
      final idToken = authentication?.idToken;
      final accessToken = authentication?.accessToken;

      if (idToken == null && accessToken == null) {
        Alert.errorAlertDialog(context, 'failed');
      } else {
        final credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // If the user is first time login thn go to credential screen else Api Call
        if (userCredential.additionalUserInfo!.isNewUser) {
          Get.to(() => const CredentialScreen());
        } else {
          final authLogin = ref.watch(authController_provider.notifier);
          User? user = FirebaseAuth.instance.currentUser;
          final currentUsersToken = await user?.getIdToken();
          // With google
          authLogin.continueWithGoogle(
            context,
            googleAuthToken: currentUsersToken ?? '',
          );
        }
      }
    }

    // ignore: avoid_print
    print(googleAccount);
    lodging = false;
    notifyListeners();
  }
}
