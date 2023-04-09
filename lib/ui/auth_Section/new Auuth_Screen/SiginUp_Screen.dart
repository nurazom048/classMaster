import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/ui/auth_Section/new%20Auuth_Screen/LogIn_Screen.dart';
import 'package:table/ui/auth_Section/widgets/Valadatoe.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertinoButttons.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
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
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 400),
          child: Column(
            children: [
              HeaderTitle("Log In", context),
              const SizedBox(height: 10),

              ///
              ///

              Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextFromField(
                      controller: nameController,
                      hint: "Name",
                      validator: (value) =>
                          SignUpValidation.validateName(value),
                      focusNode: nameFocusNode,
                      onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                    ),
                    AppTextFromField(
                      controller: emailController,
                      hint: "Email",
                      labelText: "Enter email address",
                      validator: (value) =>
                          SignUpValidation.validateEmail(value),
                      focusNode: emailFocusNode,
                      onFieldSubmitted: (_) => usernameFocusNode.requestFocus(),
                    ),
                    AppTextFromField(
                      controller: usernameController,
                      hint: "username",
                      labelText: "Couse a User for your Account",
                      validator: (value) =>
                          SignUpValidation.validateUsername(value),
                      focusNode: usernameFocusNode,
                      onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
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
                      onFieldSubmitted: (_) => formKey.currentState?.validate(),
                    ),
                  ],
                ),
              ),
              //
              const SizedBox(height: 30),
              CupertinoButtonCustom(
                color: AppColor.nokiaBlue,
                textt: "Sign up",
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    print("validate");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
