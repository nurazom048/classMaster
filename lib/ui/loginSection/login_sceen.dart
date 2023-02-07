// ignore_for_file: sized_box_for_whitespace, avoid_print, unused_local_variable, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/bottm_nev_bar.dart';
import 'package:table/ui/loginSection/create_new_account.dart';
import 'package:table/widgets/text%20and%20buttons/wellcome_top_note.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();

//........ Login .........//
  String? message;
  Future<void> login(context) async {
    try {
      //... send request
      final response = await http.post(
          Uri.parse('http://192.168.31.229:3000/auth/login'),
          body: {"username": _username.text, "password": _password.text});

      message = json.decode(response.body)["message"];

      if (response.statusCode == 200) {
        //.. responce
        final accountData = json.decode(response.body);
        final routines = json.decode(response.body)["user"]["routines"];

        //... save token
        final prefs = await SharedPreferences.getInstance();
        var savetoken = await prefs.setString('Token', accountData["token"]);

        // print(routines[1]["name"]);
        print("login");
        print(savetoken);

        // Navigate to the "routine_screen"
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNevBar()));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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

            //
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
            CupertinoButton(
              color: Colors.blue,
              child: const Text('Login'),
              onPressed: () {
                // login
                login(context);
                //
                if (message != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message!)));
                }
              },
            ),
            const SizedBox(height: 20),
            gotoCreateAccountPage(context),

            const Spacer(flex: 10),
          ],
        ),
      ),
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
