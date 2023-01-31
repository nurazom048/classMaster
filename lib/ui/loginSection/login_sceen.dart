// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
          },
        ),
      ),
    );
  }
}
