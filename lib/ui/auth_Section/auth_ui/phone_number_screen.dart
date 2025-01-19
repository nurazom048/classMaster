import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_color.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../widgets/pnone_number_textfields.dart';
import 'otp_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<PhoneNumberScreen> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    countryController.text = "+88";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitle("Log In", context),
            Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/img1.png',
                    //   width: 150,
                    //   height: 150,
                    // ),
                    const SizedBox(height: 126),
                    const Text(
                      "Phone Verification",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We need to register your phone without getting started!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    PhoneNumberTextField(
                      countryController: countryController,
                      phoneNumberController: phoneNumberController,
                      validator: (value) => validatePhoneNumber(value),
                    ),

                    const SizedBox(height: 60),

                    CupertinoButtonCustom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      color: AppColor.nokiaBlue,
                      text: "Send the code",
                      onPressed: () async {
                        String fullphoneNum =
                            countryController.text + phoneNumberController.text;
                        if (formKey.currentState?.validate() ?? false) {
                          // firebse send code to phone number
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            //phone number
                            phoneNumber: fullphoneNum,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resendToken) {
                              // go to otp screen
                              Get.to(
                                () => OtpScreen(
                                  verificationId: verificationId,
                                  phoneNumber: fullphoneNum,
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );

                          // create account
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty";
    }

    if (value.length != 11) {
      return "Phone number should be 11 digits long";
    }

    if (!value.startsWith("01")) {
      return "Phone number should start with '01'";
    }

    return null; // Return null if the input is valid
  }
}
