// ignore_for_file: sized_box_for_whitespace, avoid_print, use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';
import 'package:table/widgets/custom_textFileds.dart';
import 'package:table/widgets/text%20and%20buttons/wellcome_top_note.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CreateNewAccount> {
  //
  final name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confromPassword = TextEditingController();
  //final _username = TextEditingController();
  String? message;
//........ Login .........//
  Future createAccount() async {
    try {
      //... send request
      final response = await http
          .post(Uri.parse('http://192.168.31.229:3000/auth/create'), body: {
        "name": name.text,
        "username": _username.text,
        "password": _password.text
      });

      var res = json.decode(response.body);
      print(res);
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      print(response);
      //.. responce
      message = json.decode(response.body)["message"];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(flex: 3),
            WellComeTopHeder(
              title: 'Create A New Account',
              subtitle: "Please Login to continue",
              alignment: Alignment.topLeft,
            ),
            const Spacer(flex: 4),

            ////////
            CustomTextField(
              controller: name,
              labelText: "Full Name",
            ),
            const SizedBox(height: 20),
            //
            CustomTextField(
              controller: _username,
              labelText: "username",
            ),
            //
            const SizedBox(height: 20),
            CustomTextField(
              controller: _password,
              labelText: "Password",
            ),
            //
            const SizedBox(height: 20),
            CustomTextField(
              controller: _confromPassword,
              labelText: "Comfrom the password",
            ),

            const SizedBox(height: 40),
            CupertinoButton(
              color: Colors.blue,
              child: const Text('Create'),
              onPressed: () async {
                print("Ontap to create");
                createAccount();
                if (message != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message!)));
                }
              },
            ),

            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
