import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/widgets/custom_textFileds.dart';
import 'package:table/widgets/pickImage.dart';
import 'package:http/http.dart' as http;

class EdditAccount extends StatefulWidget {
  EdditAccount({super.key});

  @override
  State<EdditAccount> createState() => _EdditAccountState();
}

class _EdditAccountState extends State<EdditAccount> {
  @override
  void initState() {
    super.initState();
  }

  //.. Controllers
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  //
  Future<void> updateAccount(context, {name}) async {
    // get image
    final prefs = await SharedPreferences.getInstance();
    final getImagePath = prefs.getString('Image');
    final String? getToken = prefs.getString('Token');

    final url = Uri.parse('http://192.168.31.229:3000/account/eddit');

    // 1.. request
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({'Authorization': 'Bearer $getToken'});

    request.fields['name'] = name;
    if (getImagePath != null) {
      final imagePart =
          await http.MultipartFile.fromPath('image', getImagePath);
      request.files.add(imagePart);
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print('Account updated successfully');
    } else {
      print('Failed to update account: ${response.statusCode}');
    }
  }

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
                    child: const Text('Submit kor'),
                    onPressed: () async {
                      await updateAccount(
                        context,
                        name: _name.text,
                      );
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
