// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/utils/singUp_validation.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/appWidget/dotted_divider.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';

import '../widgets/siginup_page_switch.dart';
import '../widgets/who_are_you_button.dart';

final selectAccountTypeProvider = StateProvider<String>((ref) => 'Student');

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.emailAddress, this.phoneNumberString})
      : super(key: key);
  final String? emailAddress;
  final String? phoneNumberString;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final eiinController = TextEditingController();
  final contractInfoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final eiinFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.emailAddress != null) {
      emailController.text = widget.emailAddress!;
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
          final loading = ref.watch(authController_provider);

          final String selectedAccountType =
              ref.watch(selectAccountTypeProvider);
          bool? isAcademy = selectedAccountType == 'Academy';

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
                      AppTextFromField(
                        showOfftext: widget.phoneNumberString,
                        controller: emailController,
                        hint: widget.phoneNumberString != null
                            ? "PhoneNumber"
                            : "Email",
                        labelText: "Enter email address",
                        validator: (value) {
                          if (selectedAccountType == 'Academy') {
                            return SignUpValidation.validateAcademyEmail(value);
                          } else {
                            return SignUpValidation.validateEmail(value);
                          }
                        },
                        focusNode: emailFocusNode,
                        onFieldSubmitted: (_) =>
                            usernameFocusNode.requestFocus(),
                      ),
                      AppTextFromField(
                        controller: usernameController,
                        hint: "username",
                        labelText: "Chose a User for your Account",
                        validator: (value) =>
                            SignUpValidation.validateUsername(value),
                        focusNode: usernameFocusNode,
                        onFieldSubmitted: (_) {
                          if (selectedAccountType == 'Academy') {
                            return eiinFocusNode.requestFocus();
                          } else {
                            return passwordFocusNode.requestFocus();
                          }
                        },
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
                          // setState(() {});
                          // ref
                          //     .watch(selectAccountTypeProvider.notifier)
                          //     .update((state) => accountType);

                          print(accountType);
                        },
                      ),
                      const SizedBox(height: 27),
                      if (selectedAccountType == 'Academy')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Column(
                            children: [
                              Text(
                                  'To create an Academy account, it may take time to physically verify your academy.',
                                  style: TS.opensensBlue(color: Colors.black)),
                              const SizedBox(height: 10),
                              Text(
                                'To create an Academy account, please fill out the form and send a request to our team. We will review your request and accept it as soon as possible.',
                                style: TS.opensensBlue(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppTextFromField(
                                margin: EdgeInsets.zero,
                                focusNode: eiinFocusNode,
                                controller: eiinController,
                                hint: "EIIN Number",
                                validator: (value) =>
                                    SignUpValidation.validateEinNumber(value),
                                onFieldSubmitted: (_) {
                                  return passwordFocusNode.requestFocus();
                                },
                              ),
                              const SizedBox(height: 30),
                              const DotedDivider(),
                              const SizedBox(height: 1),
                              const DotedDivider(),
                              const SizedBox(height: 1),
                              const DotedDivider(),
                              const SizedBox(height: 30),
                              Text(
                                'Please provide contact information for verifying your Academy.',
                                style: TS.opensensBlue(color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'This information will allow our team to visit your academy physically for verification.',
                                style: TS.opensensBlue(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              AppTextFromField(
                                marlines: 15,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                controller: contractInfoController,
                                hint: "Contact info",
                                labelText:
                                    "Please provide the contract information for your Academy, including the current location and phone number...",
                                validator: (value) =>
                                    SignUpValidation.validateContactInfo(value),
                                focusNode: confirmPasswordFocusNode,
                                onFieldSubmitted: (_) =>
                                    formKey.currentState?.validate(),
                              ).multiline(),
                              Text(
                                'Don\'t worry, this contact information will not be visible to the public',
                                style: TS.opensensBlue(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoButtonCustom(
                  icon: isAcademy ? Icons.send : Icons.check,
                  isLoading: loading,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  color: AppColor.nokiaBlue,
                  text: isAcademy ? 'Send Create Request' : "Sign up",
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      signUp(ref);
                    }
                  },
                ),
                const SizedBox(height: 30),
                SignUpSuicherButton(
                  "Already have an account?",
                  "Log in",
                  onTap: () => Get.to(() => const SignUpScreen()),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

//
  void signUp(WidgetRef ref) async {
    //
    ref.read(authController_provider.notifier).createAccount(
          context: context,
          email: emailController.text,
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          accountType: ref.watch(selectAccountTypeProvider),
          eiinNumber: eiinController.text,
          contractInfo: contractInfoController.text,
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
    //   Alert.showSnackBar(context, 'Allrady have a acoount');
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
    //     Alert.showSnackBar(context, e);
    //   }
    // }
  }
}