// ignore_for_file: avoid_print, use_build_context_synchronously, file_names

import 'dart:math';

import 'package:classmate/core/widgets/appWidget/app_text.dart';
import 'package:classmate/core/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:classmate/core/widgets/appWidget/text_form_field.dart';
import 'package:classmate/core/widgets/heder/heder_title.dart';
import 'package:classmate/features/authentication_fetures/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:hive/hive.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/widgets/widgets/animi/auth_animi_wiggets.dart';
import '../../domain/providers/auth_controller.dart';
import '../utils/validators/sign_up_validation.dart';
import '../widgets/static_widget/sign_up_page_switch.dart';
import '../widgets/static_widget/who_are_you_button.dart';

// Required Providers & Constants (Assume these exist in your project)
final selectAccountTypeProvider = StateProvider<String>((ref) => 'student');

// ============================================================================
// PART 2: ACTUAL SIGN UP SCREEN (Form Content + Logic)
// Uses the AuthAnimationScreen wrapper to inherit the animations
// ============================================================================

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.emailAddress, this.phoneNumberString});
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
  final contractInfoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // Animation States
  double _inputProgress = 0.0;
  bool _isEyesClosed = false;
  bool _isWhistling = false;
  bool _isAngry = false;
  bool _isHappy = false;

  String _statusText = "Please enter your details";
  Color _statusColor = Colors.grey.shade500;

  @override
  void initState() {
    super.initState();

    if (widget.emailAddress != null) {
      emailController.text = widget.emailAddress!;
    }
    if (widget.phoneNumberString != null) {
      phoneNumberController.text = widget.phoneNumberString!;
    }

    try {
      var signUpInfoHive = Hive.box('signUpInfo');
      // Load stored signup data if available
      setState(() {
        emailController.text = signUpInfoHive.get('email', defaultValue: '');
        nameController.text = signUpInfoHive.get('name', defaultValue: '');
        usernameController.text = signUpInfoHive.get(
          'username',
          defaultValue: '',
        );
        passwordController.text = signUpInfoHive.get(
          'password',
          defaultValue: '',
        );
        contractInfoController.text = signUpInfoHive.get(
          'contractInfo',
          defaultValue: '',
        );
      });
      print("Loaded signup data from Hive ${emailController.text}");
    } catch (e) {
      // Hive not initialized properly in preview
    }

    // Connect text listeners for progress animation
    void updateProgress() {
      if (_isAngry || _isHappy) return;
      setState(() {
        int totalLength =
            nameController.text.length +
            emailController.text.length +
            usernameController.text.length;
        _inputProgress = min(
          totalLength / 50.0,
          1.0,
        ); // Spreads progress over 50 characters
      });
    }

    nameController.addListener(updateProgress);
    emailController.addListener(updateProgress);
    usernameController.addListener(updateProgress);

    // Connect focus listeners
    void updateFocus() {
      if (mounted) {
        setState(() {
          _isEyesClosed =
              passwordFocusNode.hasFocus || confirmPasswordFocusNode.hasFocus;
          _isWhistling = _isEyesClosed;
        });
      }
    }

    nameFocusNode.addListener(updateFocus);
    emailFocusNode.addListener(updateFocus);
    usernameFocusNode.addListener(updateFocus);
    passwordFocusNode.addListener(updateFocus);
    confirmPasswordFocusNode.addListener(updateFocus);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    contractInfoController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _resetToNormal() {
    if (mounted) {
      setState(() {
        _isAngry = false;
        _isHappy = false;
        _statusText = "Please enter your details";
        _statusColor = Colors.grey.shade500;

        bool isPassFocused =
            passwordFocusNode.hasFocus || confirmPasswordFocusNode.hasFocus;
        _isEyesClosed = isPassFocused;
        _isWhistling = isPassFocused;
      });
    }
  }

  void _triggerFeedback(bool isSuccess) {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWhistling = false;
      _isEyesClosed = false;
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
        _statusText = "Account created successfully!";
        _statusColor = Colors.green.shade500;
      });
      Future.delayed(const Duration(seconds: 3), _resetToNormal);
    }
  }

  void signUp(WidgetRef ref) async {
    try {
      var signUpInfoHive = Hive.box('signUpInfo');
      signUpInfoHive.put('email', emailController.text);
      signUpInfoHive.put('name', nameController.text);
      signUpInfoHive.put('username', usernameController.text);
      signUpInfoHive.put('password', passwordController.text);
      signUpInfoHive.put('contractInfo', contractInfoController.text);
      print("Signup data saved in Hive");
    } catch (e) {
      // Ignore hive error in preview
    }

    ref
        .read(authController_provider.notifier)
        .createAccount(
          context: context,
          email: emailController.text,
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          accountType: ref.watch(selectAccountTypeProvider),
          contractInfo: contractInfoController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final loading = ref.watch(authController_provider);
        final String selectedAccountType = ref.watch(selectAccountTypeProvider);
        bool isAcademy = selectedAccountType == 'academy';

        return AuthAnimationScreen(
          progress: _inputProgress,
          isFocused:
              nameFocusNode.hasFocus ||
              emailFocusNode.hasFocus ||
              usernameFocusNode.hasFocus,
          isEyesClosed: _isEyesClosed,
          isWhistling: _isWhistling,
          isAngry: _isAngry,
          isHappy: _isHappy,
          child: AutofillGroup(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header (Matches Login)
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
                          "Create an account",
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

                  // Name Field
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    autofillHints: const [AutofillHints.name],
                    controller: nameController,
                    hint: isAcademy ? "Academy Name" : "Name",
                    labelText:
                        isAcademy
                            ? "Enter your academy name"
                            : "Enter your full name",
                    // validator: (value) => SignUpValidation.validateName(value),
                    focusNode: nameFocusNode,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Email/Phone Field
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    autofillHints: const [AutofillHints.email],
                    hintText: widget.phoneNumberString,
                    controller: emailController,
                    hint:
                        widget.phoneNumberString != null
                            ? "Phone Number"
                            : "Email",
                    labelText: "Enter email address",
                    validator: (value) {
                      if (isAcademy) {
                        return SignUpValidation.validateAcademyEmail(value);
                      } else {
                        return SignUpValidation.validateEmail(value);
                      }
                    },
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (_) => usernameFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Username Field
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    autofillHints: const [AutofillHints.username],
                    controller: usernameController,
                    hint: "Username",
                    labelText: "Choose a Username for your Account",
                    validator:
                        (value) => SignUpValidation.validateUsername(value),
                    focusNode: usernameFocusNode,
                    onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: passwordController,
                    hint: "Password",
                    obscureText: true,
                    labelText: "Enter a strong password",
                    // validator: (value) => SignUpValidation.validatePassword(value),
                    focusNode: passwordFocusNode,
                    onFieldSubmitted:
                        (_) => confirmPasswordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    obscureText: true,
                    labelText: "Enter the same password",
                    validator:
                        (value) => SignUpValidation.validateConfirmPassword(
                          value,
                          passwordController.text,
                        ),
                    focusNode: confirmPasswordFocusNode,
                    onFieldSubmitted: (_) => formKey.currentState?.validate(),
                  ),
                  const SizedBox(height: 13),

                  // Temporary placeholder for WhoAreYouButton
                  WhoAreYouButton(
                    horizontal: 0,
                    onAccountType: (accountType) {
                      setState(() {
                        _statusText = "Selected account type: $accountType";
                        _statusColor = Colors.grey.shade500;
                      });
                      ref
                          .watch(selectAccountTypeProvider.notifier)
                          .update((state) => accountType);
                      print("Selected account type: $accountType");
                    },
                  ),
                  const SizedBox(height: 17),
                  if (isAcademy) ...[
                    AppTextFromField(
                      margin: EdgeInsets.zero,
                      autofillHints: const [AutofillHints.addressCity],
                      marlines: 10,
                      errorText: SignUpValidation.validateContactInfo(
                        contractInfoController.text,
                      ),
                      controller: contractInfoController,
                      hint: "Contact info",
                      labelText:
                          "Please provide the contact information for your academy.",
                      validator:
                          (value) =>
                              SignUpValidation.validateContactInfo(value),
                      // focusNode: confirmPasswordFocusNode,
                      onFieldSubmitted: (_) => formKey.currentState?.validate(),
                    ).multiline(),
                    const SizedBox(height: 18),

                    // Const.SignUpInfoText substitution for demo
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, i) {
                        return const BluetMarkInfoText(
                          text:
                              "Academy verification may take up to 2-3 business days.",
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 16);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Submit Button
                  CupertinoButtonCustom(
                    icon: isAcademy ? Icons.send : Icons.check,
                    isLoading: loading,
                    padding: EdgeInsets.zero,
                    color: AppColor.nokiaBlue,
                    text: isAcademy ? 'Send Create Request' : "Sign up",
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        _triggerFeedback(true);
                        signUp(ref);
                      } else {
                        _triggerFeedback(false);
                        Alert.showSnackBar(context, 'Invalid Form');
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  // Switch back to Login
                  SignUpSwitcherButton(
                    "Already have an account?",
                    "Log in",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helpers
class BluetMarkInfoText extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color? color, textColor;
  final int? flex;
  final double? radius;

  const BluetMarkInfoText({
    super.key,
    required this.text,
    this.padding,
    this.color,
    this.textColor,
    this.flex,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: padding ?? const EdgeInsets.only(right: 6.0, top: 8),
            child: CircleAvatar(
              radius: radius ?? 5,
              backgroundColor: color ?? AppColor.nokiaBlue,
            ),
          ),
        ),
        Expanded(
          flex: flex ?? 10,
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
