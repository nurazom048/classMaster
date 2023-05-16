import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../utils/change_pw_validator.dart';

class ChangePasswordPage extends ConsumerWidget {
  ChangePasswordPage({super.key});

  //
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider

    final loding = ref.watch(authController_provider);
    final authController = ref.watch(authController_provider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderTitle("Change Password", context),
              const SizedBox(height: 40),
              AppTextFromField(
                controller: currentPasswordController,
                obscureText: true,
                hint: 'Current Password',
                validator: (valu) =>
                    ChangePwValidator.validateCurrentPassword(valu),
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.nokiaBlue,
                  textt: "Change Password",
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      authController.changepassword(
                        currentPasswordController.text,
                        confirmPasswordController.text,
                        context,
                      );
                    } else {}
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
