// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:classmate/core/widgets/appWidget/app_text.dart';
import 'package:classmate/core/widgets/heder/heder_title.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/forgetpassword_screen.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/static_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../../../core/constant/image_const.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/widgets/appWidget/buttons/cupertino_buttons.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool? forgotPasswordState;
  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.forgotPasswordState = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? timer;
  bool showResendButton = false;

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (t) async => await checkVerification(),
    );
    Timer(
      const Duration(seconds: 20),
      () => setState(() => showResendButton = true),
    );
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Alert.errorAlertDialog(context, '$e'),
      );
    }
  }

  Future<void> checkVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified == true) {
      timer?.cancel();
      if (widget.forgotPasswordState == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        Navigator.of(context).pop();
        Alert.showSnackBar(context, "Email Verified Successfully");
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _auth.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StaticAuthScreen(
      imagePath: ImageConst.mailSent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Verify Email",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            widget.email,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'A verification link has been sent to your email. Please check your inbox.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          if (showResendButton) ...[
            CupertinoButtonCustom(
              color: AppColor.nokiaBlue,
              text: "Check Verification",
              onPressed: checkVerification,
            ),
            const SizedBox(height: 15),
            CupertinoButtonCustom(
              color: Colors.grey,
              text: "Resend Email",
              onPressed: sendVerificationEmail,
            ),
          ],
        ],
      ),
    );
  }
}
