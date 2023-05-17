import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/widgets/hedding_row.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/heder/heder_title.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _MyVerifyState();
}

String? pinucode;

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
          fontWeight: FontWeight.w600),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "We need to register your phone without getting started!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    length: 6,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (pin) {
                      print(pin);
                      setState(() {
                        pinucode = pin;
                      });
                    },
                  ),
                  const SizedBox(height: 60),

                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: AppColor.nokiaBlue,
                    textt: "Verify Phone Number",
                    onPressed: () {
                      // Get.to(() => const OtpScreen());
                      if (pinucode != null) {
                        // create account
                      } else {
                        Alart.showSnackBar(context, "Please EnterPin");
                      }
                    },
                  ),

                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            // Get.to(()=>);
                          },
                          child: const Text(
                            "Edit Phone Number ?",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
