import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/auth_Section/auth_ui/forgetpassword_screen.dart';
import 'package:table/widgets/appWidget/app_text.dart';

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
      print(
          '&&&${widget.email} ${widget.password} &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
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
    print("Inside sendVerificationEmail");
    try {
      await _user!.sendEmailVerification();
    } catch (e) {
      print(e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Alart.errorAlartDilog(context, '$e');
      });
    }
  }

  // Check verification
  Future<void> checkVerification() async {
    print("******************* Timer start");
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    if (user?.emailVerified == true) {
      timer?.cancel();
      Alart.errorAlartDilog(context, 'Emaile varified susr=esfull');

      // await FirebaseAuth.instance.signOut();
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //         email: widget.email, password: widget.password!)
      //     .then((value) {
      //   Alart.showSnackBar(context, 'Verified not creating account');

      //   // If for forget, go to the forget password screen; else, go to the login screen
      //   ref.read(authController_provider.notifier).createAccount(
      //         context: context,
      //         name: widget.name!,
      //         email: widget.email,
      //         username: widget.username!,
      //         password: widget.password!,
      //       );
      // });

      if (widget.forgotPasswordState == true) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Alart.showSnackBar(context, "Email Verified Successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                style: ButtonStyle(),
                onPressed: () async => sendVerificationEmail(),
                child: const Text('Resend'),
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
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.signOut();

      // if (user?.emailVerified == false) {
      //   await FirebaseAuth.instance.signOut();
      //   //await FirebaseAuth.instance.currentUser!.delete();
      // } else {
      //   await FirebaseAuth.instance.signOut();
      // }
    } catch (e) {
      Alart.showSnackBar(context, "Error deleting user: $e");
    }
  }
}
