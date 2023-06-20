// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/auth_ui/email_varification.screen.dart';
import 'package:table/ui/auth_Section/utils/singUp_validation.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/heder/heder_title.dart';

import '../widgets/siginup_page_switch.dart';
import '../widgets/who_are_you_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.emaileadress, this.phoneNumberString});
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

  bool? isAcademy;
  String? selectedAccountType;

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
                HeaderTitle("Sign Up", context),
                const SizedBox(height: 10),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFromField(
                        controller: nameController,
                        hint: isAcademy == true ? "Academy Name" : "Name",
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

                      WhoAreYouButton(
                        onAccountType: (accountType) {
                          setState(() {
                            selectedAccountType = accountType;
                          });
                          print(accountType);
                        },
                      ),

                      const SizedBox(height: 27)

                      ///
                    ],
                  ),
                ),
//_______________ Crete Buttons__________//
                const SizedBox(height: 30),

                if (loding != null && loding == true)
                  Loaders.button()
                else
                  CupertinoButtonCustom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    color: AppColor.nokiaBlue,
                    textt: "Sign up",
                    onPressed: () async {
                      //
                      if (formKey.currentState?.validate() ?? false) {
                        siginUp(ref);
                      }
                    },
                  ),

                const SizedBox(height: 30),

                SiginUpSuicherButton(
                  "Already have an account?",
                  "Log in",
                  onTap: () => Get.to(() => const SignUpScreen()),
                ),

                const SizedBox(height: 30),
                // continue with phone

                // SocialLoginButton(
                //   isphone: true,
                //   onTap: () async {
                //     Get.to(() => const PhoneNumberScreen());
                //   },
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }

//
  void siginUp(WidgetRef ref) async {
    //
    ref.read(authController_provider.notifier).createAccount(
          context: context,
          email: emailController.text,
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
        );

    // User? user = FirebaseAuth.instance.currentUser;
    // if (user?.emailVerified == true) {
    //   // ref.read(authController_provider.notifier).createAccount(
    //   //       context: context,
    //   // name: nameController.text,
    //   // email: emailController.text,
    //   // username: usernameController.text,
    //   // password: passwordController.text,
    //   //     );

    //   //   await FirebaseAuth.instance.signOut();
    //   Alart.showSnackBar(context, 'Allrady have a acoount');
    //   // Navigator.pop(context);
    // } else {
    //   // CREATE FIREBASE INSTANCE
    //   try {
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: emailController.text,
    //       password: passwordController.text,
    //     );
    //     // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     //   email: emailController.text,
    //     //   password: "@Nurazom123",
    //     // );
    //     // // GO TO EMAIL VARIFI SCREEN
    //     Get.to(
    //       () => EmailVerificationScreen(
    // email: emailController.text,
    // name: nameController.text,
    // username: usernameController.text,
    // password: passwordController.text,
    //       ),
    //     );
    //   } catch (e) {
    //     Alart.showSnackBar(context, e);
    //   }
    // }
  }
}
