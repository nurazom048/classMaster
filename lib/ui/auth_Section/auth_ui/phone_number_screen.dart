import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/heder/heder_title.dart';
import 'otp_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<PhoneNumberScreen> {
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+88";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle("Log In", context),
              Container(
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
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: countryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                              child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    CupertinoButtonCustom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      color: AppColor.nokiaBlue,
                      textt: "Send the code",
                      onPressed: () {
                        Get.to(() => const OtpScreen());
                        // if (formKey.currentState?.validate() ?? false) {
                        // create account

                        // }
                      },
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 45,
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.green.shade600,
                    //           shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10))),
                    //       onPressed: () {
                    //         // Navigator.pushNamed(context, 'verify');
                    //         Get.to(() => const OtpScreen());
                    //       },
                    //       child: const Text("Send the code")),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
