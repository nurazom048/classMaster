// ignore_for_file: sized_box_for_whitespace, avoid_print, unused_local_variable, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/auth_Section/auth_ui/create_new_account.dart';
import 'package:table/widgets/text%20and%20buttons/wellcome_top_note.dart';

class LoginScreen extends StatelessWidget {
  final _username = TextEditingController();

  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final _authLogin = ref.watch(authController_provider.notifier);
        final loding = ref.watch(authController_provider);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 3),
              WellComeTopHeder(
                alignment: Alignment.topLeft,
                title: 'Welcome Back!',
                subtitle: 'Please Login to continue',
              ),
              const Spacer(flex: 4),
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.shield_sharp),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (loding != null && loding == true)
                CupertinoButton(
                    onPressed: () {}, child: const CircularProgressIndicator())
              else
                CupertinoButton(
                  color: Colors.blue,
                  child: const Text('Login'),
                  onPressed: () async {
                    _authLogin.siginIn(_username.text, _password.text, context);
                  },
                ),
              const SizedBox(height: 20),
              gotoCreateAccountPage(context),
              const Spacer(flex: 10),
            ],
          ),
        );
      }),
    );
  }

  Expanded gotoCreateAccountPage(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?"),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // navigate to the "create account screen"
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNewAccount()));
                },
                child: const Text(
                  "Create one",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
