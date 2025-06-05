import 'package:flutter/material.dart';

import '../../screen/SignUp_Screen.dart';

class CreateAccountPopUpButton extends StatelessWidget {
  const CreateAccountPopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomLeft,
      child: TextButton(
        onPressed:
            () => showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(20, 490, 120, 100),
              items: [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Create Account for Yourself"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Create Account for Academy"),
                ),
              ],
              elevation: 8.0,
            ).then((value) {
              if (value != null) {
                if (value == 1) {
                  // Create account for yourself

                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                } else if (value == 2) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                }
              }
            }),
        child: const Text("Create an Account"),
      ),
    );
  }
}
