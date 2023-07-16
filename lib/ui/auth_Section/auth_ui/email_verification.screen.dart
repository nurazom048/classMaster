// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/auth_Section/auth_ui/forgetpassword_screen.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:classmate/widgets/heder/heder_title.dart';

import '../../../constant/image_const.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool? forgotPasswordState;
  //
  final String? name;
  final String? username;
  final String? password;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.forgotPasswordState = false,
    //
    this.name,
    this.password,
    this.username,
  });

  //
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  //
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? timer;
  bool showResendButton = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    // Step 1: Send Verification Email
    sendVerificationEmail();

    // Step 2: Check if verified or not
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await checkVerification();
    });
    Timer(const Duration(seconds: 20), () {
      setState(() {
        showResendButton = true;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    onDisposeTine();
  }

  // Send email verification
  Future<void> sendVerificationEmail() async {
    try {
      await _user!.sendEmailVerification();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Alert.errorAlertDialog(context, '$e');
      });
    }
  }

  // Check verification
  Future<void> checkVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    if (user?.emailVerified == true) {
      timer?.cancel();
      Alert.errorAlertDialog(
        context,
        'Email verified successful',
        title: 'Success',
      );

      if (widget.forgotPasswordState == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pop();
        Alert.showSnackBar(context, "Email Verified Successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HeaderTitle("Email Verification", context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 200,
                    child: SvgPicture.asset(ImageConst.mailSent),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    widget.email,
                    style: TS.heading(color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your email is not verified!',
                    style: TS.heading(),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'A verification link has been sent to your email. Please check your inbox. If you can\'t find the email, please check your spam folder.',
                    textAlign: TextAlign.justify,
                    style: TS.opensensBlue(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  if (showResendButton)
                    ElevatedButton(
                      onPressed: () async => checkVerification(),
                      child: const Text('Check Verification'),
                    ),
                  if (showResendButton) // Display the "Resend" button if showResendButton is true
                    ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () async => sendVerificationEmail(),
                      child: const Text('Resend'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDisposeTine() async {
    // Last step: Make sure if anything goes wrong, the user is not saved to Firebase
    try {
      // On dispose time, if the user is not verified, remove the user from Firebase
      await FirebaseAuth.instance.signOut();

      // if (user?.emailVerified == false) {
      //   await FirebaseAuth.instance.signOut();
      //   //await FirebaseAuth.instance.currentUser!.delete();
      // } else {
      //   await FirebaseAuth.instance.signOut();
      // }
    } catch (e) {
      Alert.showSnackBar(context, "Error deleting user: $e");
    }
  }
}
