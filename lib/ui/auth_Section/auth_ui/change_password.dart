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
  ChangePasswordPage({Key? key});

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider

    final loding = ref.watch(authController_provider);
    final authController = ref.watch(authController_provider.notifier);

    return Scaffold(
      //  appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderTitle("Change Password", context),
              const SizedBox(height: 40),
              AppTextFromField(
                controller: _currentPasswordController,
                obscureText: true,
                hint: 'Current Password',
                validator: (valu) =>
                    ChangePwValidator.validateCurrentPassword(valu),
              ),
              const SizedBox(height: 16),
              AppTextFromField(
                controller: _newPasswordController,
                obscureText: true,
                hint: 'New Password',
                validator: (valu) =>
                    ChangePwValidator.validateNewPassword(valu),
              ),
              const SizedBox(height: 16),
              AppTextFromField(
                controller: _confirmPasswordController,
                obscureText: true,
                hint: 'Confirm New Password',
                validator: (valu) => ChangePwValidator.validateConfirmPassword(
                    valu, _newPasswordController.text),
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
                    if (_formKey.currentState?.validate() ?? false) {
                      authController.changepassword(
                        _currentPasswordController.text,
                        _confirmPasswordController.text,
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
