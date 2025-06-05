// ignore_for_file: unnecessary_null_comparison

import 'package:classmate/core/widgets/appWidget/app_text.dart';
import 'package:classmate/core/widgets/appWidget/text_form_field.dart';
import 'package:classmate/core/widgets/heder/heder_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:toggle_switch/toggle_switch.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/image_const.dart';

import '../../../../core/widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../domain/providers/auth_controller.dart';
import '../utils/validators/forget_validation.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgetPasswordScreen({super.key, required this.email});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await FirebaseAuth.instance.signOut();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            final loading = ref.watch(authController_provider);
            final authController = ref.watch(authController_provider.notifier);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderTitle("Forget or Reset Password", context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 200,
                          child: SvgPicture.asset(ImageConst.forget),
                        ),
                        const SizedBox(height: 30),
                        ToggleSwitch(
                          minWidth: 130.0,
                          cornerRadius: 20.0,
                          activeBgColors: [
                            [AppColor.nokiaBlue],
                            [AppColor.nokiaBlue],
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.white,
                          inactiveFgColor: Colors.black,
                          initialLabelIndex: currentIndex,
                          totalSwitches: 2,
                          labels: const ['By Email', 'By Username'],
                          radiusStyle: true,
                          onToggle: (index) {
                            setState(() => currentIndex = index!);
                          },
                        ),
                        const SizedBox(height: 20),
                        if (currentIndex == 0)
                          Form(
                            key: formKey,
                            child: AppTextFromField(
                              margin: EdgeInsets.zero,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hint: 'Email address',
                              validator:
                                  (value) =>
                                      ForgetValidation.validateEmail(value),
                            ),
                          )
                        else
                          Form(
                            key: usernameKey,
                            child: AppTextFromField(
                              margin: EdgeInsets.zero,
                              controller: usernameController,
                              keyboardType: TextInputType.text,
                              hint: 'Username',
                              validator:
                                  (value) =>
                                      ForgetValidation.validateUsername(value),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          FORGOT_MAIL_SEND_MESSAGE_WILL_SEND,
                          style: TS.opensensBlue(color: Colors.black),
                        ),
                        const SizedBox(height: 70),
                        CupertinoButtonCustom(
                          isLoading: loading != null && loading == true,
                          color: AppColor.nokiaBlue,
                          text: "Send Reset Password Email",
                          icon: Icons.email,
                          onPressed: () async {
                            if (currentIndex == 0
                                ? formKey.currentState?.validate() ?? false
                                : usernameKey.currentState?.validate() ??
                                    false) {
                              authController.forgotPassword(
                                context,
                                email: emailController.text.trim(),
                                username: usernameController.text.trim(),
                              );
                              //=> const LoginScreen());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
