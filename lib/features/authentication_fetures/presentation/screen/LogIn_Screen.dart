// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:classmate/core/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/widgets/appWidget/text_form_field.dart';
import '../../../../core/widgets/appWidget/app_text.dart';
import '../../../../core/widgets/heder/heder_title.dart';

import '../../../../route/route_constant.dart';
import '../../domain/providers/auth_controller.dart';
import '../../domain/providers/google_auth_controller.dart';

import '../utils/validators/Login_validation.dart';
import '../widgets/static_widget/or.dart';
import '../widgets/static_widget/sign_up_page_switch.dart';
import '../widgets/static_widget/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  final String? emailAddress;
  final String? usernameAddress;
  final String? passwordAddress;
  const LoginScreen({
    super.key,
    this.emailAddress,
    this.usernameAddress,
    this.passwordAddress,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool byUsername = true;

class _LoginScreenState extends State<LoginScreen> {
  //
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.emailAddress != null) {
      if (widget.usernameAddress == null) {
        byUsername = false;
      }
      emailController.text = widget.emailAddress!;
    }
    if (widget.usernameAddress != null) {
      emailController.text = widget.usernameAddress!;
    }
    if (widget.passwordAddress != null) {
      _passwordController.text = widget.passwordAddress!;
    }
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        //
        final authLogin = ref.watch(authController_provider.notifier);
        final bool loading = ref.watch(authController_provider);
        final googleAuthProvider = ref.read(googleAuthControllerProvider);

        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 400),
                child: Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderTitle(
                          "Log In",
                          context,
                          hideArrow: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: 40),
                        const AppText("   Login To Continue").title(),
                        const SizedBox(height: 30),

                        ///
                        AppTextFromField(
                          autofillHints:
                              byUsername == true
                                  ? const [AutofillHints.username]
                                  : const [AutofillHints.email],
                          controller:
                              byUsername ? usernameController : emailController,
                          hint: byUsername ? 'Username' : "Email",
                          labelText:
                              byUsername
                                  ? "Enter Username "
                                  : "Enter email address",
                          validator: (value) {
                            if (byUsername == true) {
                              return LoginValidation.validUsername(value);
                            } else {
                              return LoginValidation.validateEmail(value);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
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
                          autofillHints: const [AutofillHints.password],
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 25,
                          ),
                          controller: _passwordController,
                          obscureText: true,
                          hint: "password",
                          labelText: "Enter a valid password",
                          validator:
                              (value) =>
                                  LoginValidation.validatePassword(value),
                        ),

                        //
                        const SizedBox(height: 30),

                        SignUpSwitcherButton(
                          "",
                          "Forgot your Password?",
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();

                            context.pushNamed(
                              RouteConst.forgetPassword,
                              extra: emailController.text.trim().toString(),
                            );
                          },
                        ),
                        const SizedBox(height: 30),

                        CupertinoButtonCustom(
                          isLoading: loading,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          color: AppColor.nokiaBlue,
                          text: "Log In",
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              authLogin.signIn(
                                context,
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            } else {
                              Alert.showSnackBar(context, 'Fill the form');
                            }
                          },
                        ),

                        //
                        const OR(),

                        SignUpSwitcherButton(
                          "Do not have an account?",
                          "Sign up",
                          onTap: () {
                            context.pushNamed(
                              RouteConst.signUp,
                              extra: emailController.text.trim().toString(),
                            );
                          },
                        ),

                        //****************************************************************************************************/
                        // --------------------------------- Continue With Google --------------------------------------------/
                        //****************************************************************************************************/
                        //const SizedBox(height: 20),
                        SocialLoginButton(
                          isLoading: googleAuthProvider.lodging || loading,
                          onTap: () {
                            googleAuthProvider.signing(context, ref);
                          },
                        ),

                        // SocialLoginButton(
                        //   iphone: true,
                        //   onTap: () async {
                        //     Navigator.push(
                        // context,
                        // MaterialPageRoute(builder: (context) => const PhoneNumberScreen()));
                        //   },
                        // ),
                        if (kDebugMode)
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  authLogin.signIn(
                                    context,
                                    username: "nurazom049",
                                    email: null,
                                    password: "@Nurazom123",
                                  );
                                },
                                // ignore: prefer_const_constructors
                                child: Text('nurazom ac'),
                              ),
                              TextButton(
                                onPressed: () {
                                  authLogin.signIn(
                                    context,
                                    username: "roma123",
                                    email: null,
                                    password: "@Rahala+Nur123",
                                  );
                                },
                                // ignore: prefer_const_constructors
                                child: Text('skip'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
