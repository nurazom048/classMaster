// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/auth_Section/auth_ui/forgetpassword_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final bool? forgotPasswordState;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.forgotPasswordState = false,
  });

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    // step:1 send Varification mail
    sendVerificationEmail(widget.email);

    // step:2 Check is varified or not
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkVerification();
    });
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();
// Last step: make sure is anythik gos to worng then dont save the user ro firebase
    try {
      // on dispose time i user is not varified then remove the user from firebse
      User? user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == false) {
        await FirebaseAuth.instance.currentUser!.delete();
      }
    } catch (e) {
      Alart.showSnackBar(context, "Error Delete user $e");
    }
  }

// send emaile varification
  Future<void> sendVerificationEmail(String email) async {
    print("inside sendVerificationEmail ");
    try {
      await _user!.sendEmailVerification();
    } catch (e) {
      print(e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Alart.errorAlartDilog(context, '$e');
      });
    }
  }
  //checkVerification

  Future<void> checkVerification() async {
    print("Tomer start");
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    timer?.cancel();
    if (user?.emailVerified == true) {
      // If for forgrt go to forget passsword screen else to to login screen

      if (widget.forgotPasswordState == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        Alart.showSnackBar(context, "EmaiVarified Sucsesfull");
        Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
