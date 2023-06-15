import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/auth_Section/auth_ui/logIn_screen.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../utils/change_pw_validator.dart';

///
///

class ForgetPasswordScreen extends StatefulWidget {
  final String email;
  const ForgetPasswordScreen({super.key, required this.email});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() async {
    super.dispose();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        //!provider

        final loding = ref.watch(authController_provider);
        final authController = ref.watch(authController_provider.notifier);
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderTitle("Forget Password", context),
              const SizedBox(height: 16),
              AppTextFromField(
                controller: newPasswordController,
                obscureText: true,
                hint: 'New Password',
                validator: (valu) =>
                    ChangePwValidator.validateNewPassword(valu),
              ),
              const SizedBox(height: 16),
              AppTextFromField(
                controller: confirmPasswordController,
                obscureText: true,
                hint: 'Confirm New Password',
                validator: (valu) => ChangePwValidator.validateConfirmPassword(
                    valu, newPasswordController.text),
              ),
              const SizedBox(height: 100),
              if (loding != null && loding == true)
                Loaders.button()
              else
                CupertinoButtonCustom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.nokiaBlue,
                  textt: "Forget Password",
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      // If Email varified
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user?.emailVerified == true) {
                        //
                        authController.forgotPassword(
                          confirmPasswordController.text,
                          context,
                          email: widget.email,
                        );
                        await FirebaseAuth.instance.signOut();
                        Get.offAll(() => const LogingScreen());
                      } else {
                        Alart.errorAlartDilog(context, "You are not Varified");
                      }
                    }
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
