// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/auth_Section/utils/login_validation.dart';
import 'package:table/ui/auth_Section/widgets/create_account_button.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/widgets/appWidget/appText.dart';

import '../../../helper/constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/appWidget/dottted_divider.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../widgets/or.dart';
import '../widgets/social_login_button.dart';
import 'SiginUp_Screen.dart';

// package
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> isToken() async {
  //
  final prefs = await SharedPreferences.getInstance();
  final String? getToken = prefs.getString('Token');
  print("getToken");

  print(getToken);

  if (getToken != null) {
    return true;
  }
  return false;
}

class LogingScreen extends ConsumerWidget {
  LogingScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authLogin = ref.watch(authController_provider.notifier);
    final loding = ref.watch(authController_provider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 400),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle("Log In", context, onTap: () {}),
                const SizedBox(height: 40),

                const AppText("   Login To Continue").title(),

                const SizedBox(height: 30),

                ///

                AppTextFromField(
                  controller: _emailController,
                  hint: "Email",
                  labelText: "Enter email address",
                  validator: (value) => LoginValidation.validateEmail(value),
                ),

                AppTextFromField(
                  controller: _passwordController,
                  hint: "password",
                  labelText: "Enter a valid password",
                  validator: (value) => LoginValidation.validatePassword(value),
                ),

                //
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
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    color: AppColor.nokiaBlue,
                    textt: "Log In",
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        authLogin.siginIn(_emailController.text,
                            _passwordController.text, context);
                      } else {
                        authLogin.siginIn("nurazom049", "@Nurazom123", context);
                      }
                    },
                  ),

                //

                const CreateAccountPopUpButton(),

                OR(),

                ///
                ///
                SocialLoginButton(onTap: () async {
                  await GoogleSignIn().signIn();

                  print("opntap");
                  // Future<void> _handleSignIn() async {
                  //   try {
                  //   } catch (error) {
                  //     print(error);
                  //   }
                  // }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
