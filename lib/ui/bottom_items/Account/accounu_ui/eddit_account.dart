// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/pickImage.dart';
import '../../../../widgets/heder/hederTitle.dart';
import '../../../auth_Section/utils/singUp_validation.dart';

class EdditAccount extends StatefulWidget {
  final String accountUsername;
  const EdditAccount({super.key, required this.accountUsername});

  @override
  State<EdditAccount> createState() => _EdditAccountState();
}

class _EdditAccountState extends State<EdditAccount> {
  //.. Controllers
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

  String? imagePath;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle("Eddit Account", context),
              PickImage(
                onImagePathSelected: (inagePath) async {
                  imagePath = inagePath;

                  print("path paici vai $imagePath");
                },
              ),
              AppTextFromField(
                controller: nameController,
                hint: "Name",
                validator: (value) => SignUpValidation.validateName(value),
                focusNode: nameFocusNode,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
              ),
              AppTextFromField(
                controller: emailController,
                hint: "Email",
                labelText: "Enter email address",
                validator: (value) => SignUpValidation.validateEmail(value),
                focusNode: emailFocusNode,
                onFieldSubmitted: (_) => usernameFocusNode.requestFocus(),
              ),
              AppTextFromField(
                controller: usernameController,
                hint: "username",
                labelText: "Couse a User for your Account",
                validator: (value) => SignUpValidation.validateUsername(value),
                focusNode: usernameFocusNode,
                onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
              ),
              // AppTextFromField(
              //   controller: passwordController,
              //   hint: "password",
              //   labelText: "Enter a valid password",
              //   validator: (value) => SignUpValidation.validatePassword(value),
              //   focusNode: passwordFocusNode,
              //   onFieldSubmitted: (_) =>
              //       confirmPasswordFocusNode.requestFocus(),
              // ),
              // AppTextFromField(
              //   controller: confirmPasswordController,
              //   hint: "Confirm Password",
              //   labelText: "Enter the same password",
              //   validator: (value) => SignUpValidation.validateConfirmPassword(
              //       value, passwordController.text),
              //   focusNode: confirmPasswordFocusNode,
              //   onFieldSubmitted: (_) => formKey.currentState?.validate(),
              // ),
              const SizedBox(height: 20),

              // update Account
              CupertinoButton(
                  color: Colors.blue,
                  child: const Text('Eddit Account'),
                  onPressed: () async {
                    await AccountReq().updateAccount(context,
                        name: nameController.text, imagePath: imagePath);
                  }),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
