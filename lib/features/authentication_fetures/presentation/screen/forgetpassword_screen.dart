// ignore_for_file: unnecessary_null_comparison

import 'package:classmate/core/widgets/appWidget/app_text.dart';
import 'package:classmate/core/widgets/appWidget/text_form_field.dart';
import 'package:classmate/core/widgets/heder/heder_title.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/static_auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:toggle_switch/toggle_switch.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/image_const.dart';

import '../../../../core/widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../domain/providers/auth_controller.dart';
import '../utils/validators/forget_validation.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? email;
  const ForgetPasswordScreen({super.key, required this.email});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) emailController.text = widget.email!;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final loading = ref.watch(authController_provider);
        final authController = ref.watch(authController_provider.notifier);

        return StaticAuthScreen(
          imagePath: ImageConst.forget,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ToggleSwitch(
                  minWidth: 130.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [AppColor.nokiaBlue],
                    [AppColor.nokiaBlue],
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  inactiveFgColor: Colors.black,
                  initialLabelIndex: currentIndex,
                  totalSwitches: 2,
                  labels: const ['By Email', 'By Username'],
                  onToggle: (index) => setState(() => currentIndex = index!),
                ),
              ),
              const SizedBox(height: 30),
              if (currentIndex == 0)
                Form(
                  key: formKey,
                  child: AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: emailController,
                    hint: 'Email address',
                    validator: (value) => ForgetValidation.validateEmail(value),
                  ),
                )
              else
                Form(
                  key: usernameKey,
                  child: AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: usernameController,
                    hint: 'Username',
                    validator:
                        (value) => ForgetValidation.validateUsername(value),
                  ),
                ),
              const SizedBox(height: 30),
              CupertinoButtonCustom(
                isLoading: loading ?? false,
                color: AppColor.nokiaBlue,
                text: "Send Reset Link",
                icon: Icons.email,
                onPressed: () {
                  if (currentIndex == 0
                      ? formKey.currentState?.validate() ?? false
                      : usernameKey.currentState?.validate() ?? false) {
                    authController.forgotPassword(
                      context,
                      email: emailController.text.trim(),
                      username: usernameController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
