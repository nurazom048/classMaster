// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table/ui/all_rutins.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _Username = TextEditingController();

  final _password = TextEditingController();

  ///
  Future<void> fetchData() async {
    try {
      print(username);
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
  void _Login(context) async {
    try {
      final response = await http.post(
          Uri.parse('http://192.168.31.229:3000/auth/login'),
          body: {"username": _Username.text, "password": _password.text});

      //

      if (response.statusCode == 200) {
        final accountData = json.decode(response.body);

        final routines = json.decode(response.body)["user"]["routines"];

        // print(routines[1]["name"]);
        // print(routines.runtimeType);

        // Navigate to the "routine_screen"
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllRutins(myrutines: routines),
            ));

        //print(accountData['user']['routines']);
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
                    controller: _Username,
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
                      // login logic
                      _Login(context);
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

class RoutineScreen extends StatelessWidget {
  final List<dynamic> routines;

  RoutineScreen({required this.routines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routines"),
      ),

      // body: Column(
      //   children: [
      //     Text(routines[0]["name"]),
      //     Text(routines[2]["name"]),
      //     Text(routines[2]["ownerid"]),
      //   ],
      // ),

      body: ListView.builder(
        itemCount: routines.length,
        itemBuilder: (context, index) {
          routines.length;
          return ListTile(
            title: Text(routines[index]["name"]),
            subtitle: Text("Owner ID: ${routines[index]["ownerid"]}"),
            // trailing: routines["class"].length > 0
            //     ? Text("Classes: ${routines["class"].length}")
            //     : null,
          );
        },
      ),
    );
  }
}
