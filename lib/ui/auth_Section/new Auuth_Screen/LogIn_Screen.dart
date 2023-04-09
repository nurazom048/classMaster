import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import '../../../widgets/appWidget/TextFromFild.dart';

class LogingScreen extends ConsumerWidget {
  LogingScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 400),
          child: Column(
            children: [
              HeaderTitle("Log In", context),
              const SizedBox(height: 100),

              ///
              ///
              ///

              AppTextFromField(
                controller: _emailController,
                hint: "Email",
                labelText: "Enter email address",
              ),

              AppTextFromField(
                controller: _passwordController,
                hint: "password",
                labelText: "Enter a valid password",
              ),

              //
              const SizedBox(height: 30),
              const CupertinoButtonCustom(
                textt: "Log In",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
    this.title,
    this.context, {
    super.key,
  });
  final String title;
  final BuildContext context;
  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: const EdgeInsets.only(left: 25.5, top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios, size: 20)),
          AppText(title: title),
        ],
      ),
    );
  }
}
