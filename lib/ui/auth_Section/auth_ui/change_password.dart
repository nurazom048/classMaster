import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/app_color.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';
import '../auth_controller/auth_controller.dart';
import '../utils/change_pw_validator.dart';

class ChangePasswordPage extends ConsumerWidget {
  ChangePasswordPage({Key? key}) : super(key: key);
  // key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providers
    final loading = ref.watch(authController_provider);
    final authController = ref.watch(authController_provider.notifier);

    // Text editing controllers
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   bottom: PreferredSize(
        //     preferredSize: MediaQuery.of(context).size / 40,
        //     child: HeaderTitle("Change Password", context),
        //   ),
        // ),
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
                  // obscureText: true,
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
                    if (formKey.currentState?.validate() ?? false) {
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
