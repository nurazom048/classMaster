import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../utils/change_pw_validator.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  // key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Text editing controllers
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Providers
    final loading = ref.watch(authController_provider);
    final authController = ref.watch(authController_provider.notifier);

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeaderTitle('Change Password', context),
                const SizedBox(height: 20),
                AppTextFromField(
                  controller: currentPasswordController,
                  hint: 'Current Password',
                  validator: (value) =>
                      ChangePwValidator.validateCurrentPassword(value),
                ),
                const SizedBox(height: 16),
                AppTextFromField(
                  controller: newPasswordController,
                  obscureText: true,
                  hint: 'New Password',
                  validator: (value) =>
                      ChangePwValidator.validateNewPassword(value),
                ),
                const SizedBox(height: 16),
                AppTextFromField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hint: 'Confirm New Password',
                  validator: (value) =>
                      ChangePwValidator.validateConfirmPassword(
                    value,
                    newPasswordController.text,
                  ),
                ),
                const SizedBox(height: 100),
                CupertinoButtonCustom(
                  icon: Icons.check,
                  isLoading: loading,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: AppColor.nokiaBlue,
                  text: "Change Password",
                  onPressed: () async {
                    // Unfocus the current keyboard to hide it
                    FocusScope.of(context).unfocus();

                    // Validate the form
                    if (formKey.currentState?.validate() ?? false) {
                      // Call the password change method
                      authController.changepassword(
                        currentPasswordController.text,
                        confirmPasswordController.text,
                        context,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
