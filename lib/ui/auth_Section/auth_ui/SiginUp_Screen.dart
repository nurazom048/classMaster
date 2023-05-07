import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/app_color.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/utils/singUp_validation.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/heder/heder_title.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key, this.isAcademy});
  final bool? isAcademy;

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
    //! PROVIDER
    final loding = ref.watch(authController_provider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                      hint: isAcademy == true ? "Academy Name" : "Name",
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
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // create account
                      ref.read(authController_provider.notifier).createAccount(
                            context: context,
                            name: nameController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );
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
