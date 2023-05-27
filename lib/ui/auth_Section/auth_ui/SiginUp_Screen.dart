// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/auth_ui/email_varification.screen.dart';
import 'package:table/ui/auth_Section/utils/singUp_validation.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/heder/heder_title.dart';
import 'package:email_auth/email_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen(
      {super.key, this.isAcademy, this.emaileadress, this.phoneNumberString});
  final bool? isAcademy;
  final String? emaileadress;
  final String? phoneNumberString;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  //
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.emaileadress != null) {
      emailController.text = widget.emaileadress!;
    }

    if (widget.phoneNumberString != null) {
      emailController.text = widget.phoneNumberString!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          //! PROVIDER
          final loding = ref.watch(authController_provider);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 400),
            child: Column(
              children: [
                HeaderTitle("Log In", context),
                const SizedBox(height: 10),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFromField(
                        controller: nameController,
                        hint:
                            widget.isAcademy == true ? "Academy Name" : "Name",
                        validator: (value) =>
                            SignUpValidation.validateName(value),
                        focusNode: nameFocusNode,
                        onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                      ),
                      // Email and phone number
                      AppTextFromField(
                        showOfftext: widget.phoneNumberString,
                        controller: emailController,
                        hint: widget.phoneNumberString != null
                            ? "PhoneNumber"
                            : "Email",
                        labelText: "Enter email address",
                        validator: (value) =>
                            SignUpValidation.validateEmail(value),
                        focusNode: emailFocusNode,
                        onFieldSubmitted: (_) =>
                            usernameFocusNode.requestFocus(),
                      ),
                      AppTextFromField(
                        controller: usernameController,
                        hint: "username",
                        labelText: "Couse a User for your Account",
                        validator: (value) =>
                            SignUpValidation.validateUsername(value),
                        focusNode: usernameFocusNode,
                        onFieldSubmitted: (_) =>
                            passwordFocusNode.requestFocus(),
                      ),
                      AppTextFromField(
                        controller: passwordController,
                        hint: "password",
                        labelText: "Enter a valid password",
                        validator: (value) =>
                            SignUpValidation.validatePassword(value),
                        focusNode: passwordFocusNode,
                        onFieldSubmitted: (_) =>
                            confirmPasswordFocusNode.requestFocus(),
                      ),
                      AppTextFromField(
                        controller: confirmPasswordController,
                        hint: "Confirm Password",
                        labelText: "Enter the same password",
                        validator: (value) =>
                            SignUpValidation.validateConfirmPassword(
                                value, passwordController.text),
                        focusNode: confirmPasswordFocusNode,
                        onFieldSubmitted: (_) =>
                            formKey.currentState?.validate(),
                      ),
                    ],
                  ),
                ),
//_______________ Crete Buttons__________//
                const SizedBox(height: 30),

                if (loding != null && loding == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {},
                        child: const CircularProgressIndicator(),
                      ),
                    ],
                  )
                else
                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    color: AppColor.nokiaBlue,
                    textt: "Sign up",
                    onPressed: () async {
                      //
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: "nurazom049@gmail.com",
                        password: "@Nurazom123",
                      );

                      //
                      Get.to(() => EmailVerificationScreen(
                          email: "nurazom049@gmail.com"));

                      if (formKey.currentState?.validate() ?? false) {}
                      // Get.to(() => EmailVerificationScreen(
                      //     email: emailController.text));

                      // // create account
                      // ref
                      //     .read(authController_provider.notifier)
                      //     .createAccount(
                      //       context: context,
                      //       name: nameController.text,
                      //       email: emailController.text,
                      //       username: usernameController.text,
                      //       password: passwordController.text,
                      //     );
                    },
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
