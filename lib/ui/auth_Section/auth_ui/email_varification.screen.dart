import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? timer;
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    sendVerificationEmail(widget.email);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkVerification();
    });
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();

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
      _showDialog = true;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Alart.errorAlartDilog(context, '$e');
      });
    }
  }
  //checkVerification

  Future<void> checkVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    timer?.cancel();
    if (user?.emailVerified == true) {
      Get.to(() => HomeScreen());
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
              onPressed: () async {
                checkVerification();
                User? user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified == false) {
                  Alart.errorAlartDilog(
                      context, "Please verify your email before proceeding");
                }
              },
              child: const Text('Check Verification'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('You are logged in!'),
      ),
    );
  }
}
