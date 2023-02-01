// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  ///
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.31.229:3000/ok'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  String username = "We";
//

  void _Login() async {
    try {
      final response = await http.post(
          Uri.parse('https://reqres.in/api/register'),
          body: {"email": "eve.holt@reqres.in", "password": "cityslicka"});

      //

      print(response.body);
      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);
        print(accountData);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(flex: 3),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Please Login to continue',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(flex: 4),
            Container(
              width: 300,
              child: Column(
                children: [
                  TextFormField(
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
                      // login logic
                      _Login();
                    },
                  )
                ],
              ),
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 100,
        width: double.infinity,
        alignment: Alignment.bottomRight,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(35),
          color: Colors.blue,
          child: const Text('skip'),
          onPressed: () {
            // login logic
            fetchData();
            print("clicked");
          },
        ),
      ),
    );
  }
}
