import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/utils/Login_validation.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/heder/hederTitle.dart';

class LogingScreen extends ConsumerWidget {
  LogingScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authLogin = ref.watch(authController_provider.notifier);
    final loding = ref.watch(authController_provider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 400),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle("Log In", context, onTap: () {}),
                const SizedBox(height: 40),

                const AppText("   Login To Continue").title(),

                const SizedBox(height: 30),

                ///

                AppTextFromField(
                  controller: _emailController,
                  hint: "Email",
                  labelText: "Enter email address",
                  validator: (value) => LoginValidation.validateEmail(value),
                ),

                AppTextFromField(
                  controller: _passwordController,
                  hint: "password",
                  labelText: "Enter a valid password",
                  validator: (value) => LoginValidation.validatePassword(value),
                ),

                //
                const SizedBox(height: 30),

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
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    textt: "Log In",
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        authLogin.siginIn(_emailController.text,
                            _passwordController.text, context);
                      }
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
