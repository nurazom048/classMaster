import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/auth_Section/auth_ui/forgetpassword_screen.dart';

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
  void dispose() async {
    timer?.cancel();
    super.dispose();
    // Last step: Make sure if anything goes wrong, the user is not saved to Firebase
    try {
      // On dispose time, if the user is not verified, remove the user from Firebase
      User? user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == false) {
        await FirebaseAuth.instance.signOut();
        //await FirebaseAuth.instance.currentUser!.delete();
      } else {
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      Alart.showSnackBar(context, "Error deleting user: $e");
    }
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        Alart.showSnackBar(context, "Email Verified Successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'An email has been sent to:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please check your email and click on the verification link to proceed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => checkVerification(),
              child: const Text('Check Verification'),
            ),
            if (showResendButton) // Display the "Resend" button if showResendButton is true
              ElevatedButton(
                onPressed: () async => sendVerificationEmail(),
                child: const Text('Resend'),
              ),
          ],
        ),
      ),
    );
  }
}
