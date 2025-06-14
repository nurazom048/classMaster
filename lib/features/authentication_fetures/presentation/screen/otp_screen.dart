// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:classmate/core/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/widgets/heder/heder_title.dart';
import 'signup_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String? phoneNumber;
  const OtpScreen({super.key, required this.verificationId, this.phoneNumber});

  @override
  State<OtpScreen> createState() => _MyVerifyState();
}

String? smsCode;

class _MyVerifyState extends State<OtpScreen> {
  @override
  //
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitle("", context),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/varifiaotp.png',
                  //   width: 150,
                  //   height: 150,
                  // ),
                  const SizedBox(height: 126),
                  const Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We need to register your phone without getting started!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    length: 6,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) {
                      setState(() {
                        smsCode = pin;
                      });
                    },
                  ),
                  const SizedBox(height: 60),

                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: AppColor.nokiaBlue,
                    text: "Verify Phone Number",
                    onPressed: () async {
                      if (smsCode != null) {
                        try {
                          // Verify OTP
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: smsCode!,
                              );

                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);

                          // ignore: use_build_context_synchronously
                          Alert.showSnackBar(context, "Verify success");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SignUpScreen(
                                    phoneNumberString: widget.phoneNumber,
                                  ),
                            ),
                          );
                        } catch (e) {
                          Alert.showSnackBar(context, e.toString());
                        }
                      } else {
                        Alert.showSnackBar(context, "Please Enter PIN");
                      }
                    },
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          // context,
                          // MaterialPageRoute(builder: (context)=>);
                        },
                        child: const Text(
                          "Edit Phone Number ?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
