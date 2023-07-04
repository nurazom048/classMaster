import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/ui/auth_Section/auth_ui/SignUp_Screen.dart';
import 'package:table/ui/auth_Section/utils/login_validation.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../auth_controller/google_auth_controller.dart';
import '../widgets/or.dart';
import '../widgets/siginup_page_switch.dart';
import 'forgetpassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool byUsername = true;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //
      final authLogin = ref.watch(authController_provider.notifier);
      final loding = ref.watch(authController_provider);

      return WillPopScope(
        onWillPop: () => Future.value(true),
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 400),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderTitle("Log In", context),
                    const SizedBox(height: 40),
                    const AppText("   Login To Continue").title(),
                    const SizedBox(height: 30),

                    ///

                    AppTextFromField(
                      controller:
                          byUsername ? usernameController : _emailController,
                      hint: byUsername ? 'Username' : "Email",
                      labelText: byUsername
                          ? "Enter Username "
                          : "Enter email address",
                      validator: (value) {
                        if (byUsername) {
                          return LoginValidation.validUsername(value);
                        } else {
                          return LoginValidation.validateEmail(value);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() => byUsername = !byUsername);
                            },
                            child: Text(
                              byUsername ? 'With Email?' : 'With Username?',
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppTextFromField(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      controller: _passwordController,
                      obscureText: true,
                      hint: "password",
                      labelText: "Enter a valid password",
                      validator: (value) =>
                          LoginValidation.validatePassword(value),
                    ),

                    //
                    const SizedBox(height: 30),

                    SignUpSuicherButton("", "Forgot your Password?",
                        onTap: () async {
                      // if (emailkey.currentState?.validate() ?? false) {
                      // try {
                      await FirebaseAuth.instance.signOut();
                      return Get.to(() => ForgetPasswordScreen(
                            email: _emailController.text,
                          ));

                      // return Get.to(() => EmailVerificationScreen(
                      //       email: _emailController.text,
                      //       forgotPasswordState: true,
                      // ));
                      // Get.to(() => ForgetPasswordScreen(
                      //       email: _emailController.text,
                      //     ));
                      // } on FirebaseAuthMultiFactorException catch (e) {
                      //   Alert.showSnackBar(context, e);
                      // }

                      // //
                    }),
                    const SizedBox(height: 30),

                    CupertinoButtonCustom(
                      isLoading: loding,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      color: AppColor.nokiaBlue,
                      text: "Log In",
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          authLogin.signIn(_emailController.text,
                              _passwordController.text, context);
                        } else {
                          authLogin.signIn(
                              "roma123", "@Rahala+Nur123", context);
                        }
                      },
                    ),

                    //

                    const OR(),

                    SignUpSuicherButton(
                      "Do not have an account?",
                      "Sign up",
                      onTap: () => Get.to(() => const SignUpScreen()),
                    ),

                    ///
                    ///
                    // ref.watch(gooleAuthControllerProvider).lodging == true
                    //     ? const SizedBox(
                    //         height: 20, width: 20, child: Progressindicator())
                    //     : SocialLoginButton(
                    //         onTap: () async {
                    //           ref
                    //               .read(gooleAuthControllerProvider)
                    //               .signin(context);

                    //           if (ref
                    //                   .watch(gooleAuthControllerProvider)
                    //                   .googleAccount !=
                    //               null) {}
                    //         },
                    //       ),

                    // // continue with phone

                    // SocialLoginButton(
                    //   iphone: true,
                    //   onTap: () async {
                    //     Get.to(() => const PhoneNumberScreen());
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CredentialScreen extends ConsumerWidget {
  const CredentialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final googleUser = ref.watch(googleAuthControllerProvider).googleAccount;
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
