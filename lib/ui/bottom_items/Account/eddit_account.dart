import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/widgets/AppBarCustom.dart';
import 'package:table/widgets/custom_textFileds.dart';
import 'package:table/widgets/pickImage.dart';

class EdditAccount extends StatefulWidget {
  EdditAccount({super.key});

  @override
  State<EdditAccount> createState() => _EdditAccountState();
}

class _EdditAccountState extends State<EdditAccount> {
  //.. Controllers
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Eddit Account")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                PickImage(),
                //.. Username ..//

                ////////
                CustomTextField(
                  controller: _name,
                  labelText: "Full Name",
                ),
                const SizedBox(height: 20),
                //
                // CustomTextField(
                //   controller: _username,
                //   labelText: "username",
                // ),
                //
                const SizedBox(height: 20),
                // CustomTextField(
                //   controller: _password,
                //   labelText: "Password",
                // ),
                //
                const SizedBox(height: 20),
                // CustomTextField(
                //   controller: _confromPassword,
                //   labelText: "Comfrom the password",
                // ),
                CupertinoButton(
                    color: Colors.blue,
                    child: const Text('Submit'),
                    onPressed: () async {
                      // get image
                      final prefs = await SharedPreferences.getInstance();
                      final getImage = prefs.getString('Image');
                      print(getImage);
                    }),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
