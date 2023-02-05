// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table/ui/all_rutins.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/widgets/text%20and%20buttons/wellcome_top_note.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CreateNewAccount> {
  //
  final _fullname = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  //final _password = TextEditingController();
  //final _username = TextEditingController();

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
              controller: _username,
              labelText: "username",
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
              controller: _username,
              labelText: "username",
            ),
            //
            const SizedBox(height: 20),
            CustomTextField(
              controller: _username,
              labelText: "username",
            ),

            const SizedBox(height: 40),
            CupertinoButton(
              color: Colors.blue,
              child: const Text('Create'),
              onPressed: () {
                // create logic
              },
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
