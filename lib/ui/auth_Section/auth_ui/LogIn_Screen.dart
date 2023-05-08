import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/auth_Section/utils/login_validation.dart';
import 'package:table/ui/auth_Section/widgets/create_account_button.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../auth_controller/google_auth_controller.dart';
import '../widgets/or.dart';
import '../widgets/social_login_button.dart';

Future<bool> isToken() async {
  //
  final prefs = await SharedPreferences.getInstance();
  final String? getToken = prefs.getString('Token');
  // ignore: avoid_print
  print("getToken");

  // ignore: avoid_print
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

                const OR(),

                ///
                ///
                ref.watch(gooleAuthControllerProvider).lodging == true
                    ? const SizedBox(
                        height: 20, width: 20, child: Progressindicator())
                    : SocialLoginButton(onTap: () async {
                        ref.read(gooleAuthControllerProvider).signin(context);

                        if (ref
                                .watch(gooleAuthControllerProvider)
                                .googleAccount !=
                            null) {}
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreadiantialScreen extends ConsumerWidget {
  const CreadiantialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final googleUser = ref.watch(gooleAuthControllerProvider).googleAccount;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (googleUser != null && googleUser.photoUrl != null)
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(googleUser.photoUrl!),
              ),
            Text("id: ${googleUser?.id}"),
            Text("Name: ${googleUser?.displayName}"),
            Text("Email: ${googleUser?.email}"),
            //

            Text("Heder: ${googleUser?.authHeaders}"),
            Text("server auth: ${googleUser?.serverAuthCode}"),
          ],
        ),
      ),
    );
  }
}
