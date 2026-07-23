// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:classmate/core/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:classmate/core/widgets/widgets/animi/auth_animi_wiggets.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/charcater_painter.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/forget_password_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/widgets/appWidget/text_form_field.dart';
import '../../../../core/widgets/appWidget/app_text.dart';
import '../../../../core/widgets/heder/heder_title.dart';

import '../../../../route/route_constant.dart';
import '../../../../core/local_data/local_data.dart';
import '../../data/services/credential_save_service.dart';
import '../../domain/providers/auth_controller.dart';
import '../../domain/providers/google_auth_controller.dart';

import '../utils/validators/login_validation.dart';
import '../widgets/static_widget/or.dart';
import '../widgets/static_widget/sign_up_page_switch.dart';
import '../widgets/static_widget/social_login_button.dart';
import 'dart:async';
import 'dart:math';

class AnimatedLoginScreen extends StatelessWidget {
  const AnimatedLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFEAEAEF),
      ),
      home: const LoginScreen(),
    );
  }
}

// ============================================================================
// PART 2: ACTUAL LOGIN SCREEN (Form Content + Logic)
// Uses the AuthAnimationScreen wrapper to inherit the animations
// ============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isRememberMe = false;
  bool _byUsername = false;

  // Trackable states passed down to the reusable animation wrapper
  double _inputProgress = 0.0;
  bool _isWhistling = false;
  bool _isAngry = false;
  bool _isHappy = false;

  String _statusText = "Please enter your details";
  Color _statusColor = Colors.grey.shade500;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    void updateProgress() {
      if (_isAngry || _isHappy) return;
      setState(() {
        final textLength =
            _byUsername
                ? _usernameController.text.length
                : _emailController.text.length;
        _inputProgress = min(textLength / 30.0, 1.0);
      });
    }

    _emailController.addListener(updateProgress);
    _usernameController.addListener(updateProgress);

    _emailFocus.addListener(() {
      setState(() {});
    });

    _passwordFocus.addListener(() {
      if (_isAngry || _isHappy || _isPasswordVisible) return;
      setState(() {
        _isWhistling = _passwordFocus.hasFocus;
      });
    });
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await CredentialSaveService.getSavedCredentials();
    if (credentials.isEmpty) return;

    setState(() {
      if (credentials['username'] != null &&
          credentials['username']!.isNotEmpty) {
        _byUsername = true;
        _usernameController.text = credentials['username']!;
      } else if (credentials['email'] != null &&
          credentials['email']!.isNotEmpty) {
        _byUsername = false;
        _emailController.text = credentials['email']!;
      }
      if (credentials['password'] != null) {
        _passwordController.text = credentials['password']!;
      }

      // Update progress bar
      final textLength =
          _byUsername
              ? _usernameController.text.length
              : _emailController.text.length;
      _inputProgress = min(textLength / 30.0, 1.0);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _resetToNormal() {
    if (mounted) {
      setState(() {
        _isAngry = false;
        _isHappy = false;
        _statusText = "Please enter your details";
        _statusColor = Colors.grey.shade500;
        if (_passwordFocus.hasFocus && !_isPasswordVisible) {
          _isWhistling = true;
        }
      });
    }
  }

  void _triggerFeedback(bool isSuccess) {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWhistling = false;
    });

    if (!isSuccess) {
      setState(() {
        _isAngry = true;
        _statusText = "Validation Failed! Please check fields.";
        _statusColor = Colors.red.shade500;
      });
      Future.delayed(const Duration(seconds: 2), _resetToNormal);
    } else {
      setState(() {
        _isHappy = true;
        _statusText = "Processing login details...";
        _statusColor = Colors.green.shade500;
      });
      Future.delayed(const Duration(seconds: 3), _resetToNormal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authLogin = ref.watch(authController_provider.notifier);
        final bool loading = ref.watch(authController_provider);
        final googleAuthProvider = ref.read(googleAuthControllerProvider);

        // Wrap the form inside our highly reusable Animation Screen
        return AuthAnimationScreen(
          progress: _inputProgress,
          isFocused: _emailFocus.hasFocus,
          isEyesClosed:
              _isPasswordVisible ||
              (_passwordFocus.hasFocus && !_isPasswordVisible),
          isWhistling: _isWhistling,
          isAngry: _isAngry,
          isHappy: _isHappy,
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header (Logo & Title)
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/png/logo.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if logo fails to load
                                return Icon(
                                  Icons.school,
                                  color: AppColor.nokiaBlue,
                                  size: 36,
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Class Master",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _statusText,
                          style: TextStyle(
                            fontSize: 14,
                            color: _statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email/Username Field
                  AppTextFromField(
                    focusNode: _emailFocus,
                    margin: EdgeInsets.zero,
                    autofillHints:
                        _byUsername
                            ? const [AutofillHints.username]
                            : const [AutofillHints.email],
                    controller:
                        _byUsername ? _usernameController : _emailController,
                    hint: _byUsername ? 'Username' : "Email",
                    labelText:
                        _byUsername ? "Enter Username" : "Enter email address",
                    validator: (value) {
                      if (_byUsername) {
                        return LoginValidation.validUsername(value);
                      } else {
                        return LoginValidation.validateEmail(value);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _byUsername = !_byUsername;
                              _emailController.clear();
                              _usernameController.clear();
                              _emailFocus.requestFocus();
                            });
                          },
                          child: Text(
                            _byUsername ? 'With Email?' : 'With Username?',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Password Field
                  AppTextFromField(
                    focusNode: _passwordFocus,
                    margin: EdgeInsets.zero,
                    autofillHints: const [AutofillHints.password],
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    hint: "Password",
                    labelText: "••••••••",
                    validator:
                        (value) => LoginValidation.validatePassword(value),
                  ),

                  const SizedBox(height: 16),

                  // Forget password
                  ForgetPasswordBtn(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      context.pushNamed(
                        RouteConst.forgetPassword,
                        extra: _emailController.text.trim().toString(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Custom Login Button with Validation
                  CupertinoButtonCustom(
                    isLoading: loading,
                    padding: EdgeInsets.zero,
                    color: AppColor.nokiaBlue,
                    text: "Log In",
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _triggerFeedback(true);
                        authLogin.signIn(
                          context,
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      } else {
                        _triggerFeedback(false);
                        Alert.showSnackBar(context, 'Fill the form');
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Google Login Button
                      Expanded(
                        child: SocialLoginButton(
                          margin: EdgeInsets.zero,
                          isLoading: false,
                          onTap: () {
                            googleAuthProvider.signing(context, ref);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Guest Login Button
                      Expanded(
                        child: SocialLoginButton(
                          margin: EdgeInsets.zero,
                          backgroundColor: Colors.blueGrey.shade50,
                          textColor: Colors.blueGrey.shade700,
                          icon: Icon(
                            Icons.explore_outlined,
                            color: Colors.blueGrey.shade700,
                            size: 20,
                          ),
                          text: "Explore",
                          isLoading: false,
                          onTap: () async {
                            final router = GoRouter.of(context);
                            await LocalData.emptyLocal();
                            await LocalData.saveIsGuest(true);
                            router.go('/home');
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RouteConst.signUp,
                          extra: _emailController.text.trim().toString(),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 22, 75, 182),
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
