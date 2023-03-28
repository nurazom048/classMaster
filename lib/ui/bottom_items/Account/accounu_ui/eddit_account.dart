// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/widgets/custom_textFileds.dart';
import 'package:table/widgets/pickImage.dart';
import 'package:http/http.dart' as http;

class EdditAccount extends StatefulWidget {
  final String accountUsername;
  const EdditAccount({super.key, required this.accountUsername});

  @override
  State<EdditAccount> createState() => _EdditAccountState();
}

class _EdditAccountState extends State<EdditAccount> {
  //.. Controllers
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  //
  Future<void> updateAccount(context, {name, imagePath}) async {
    // get image
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final url = Uri.parse('${Const.BASE_URl}/account/eddit');

    // 1.. request
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({'Authorization': 'Bearer $getToken'});

    request.fields['image'] = name;
    if (imagePath != null) {
      final imagePart = await http.MultipartFile.fromPath('image', imagePath);
      print("image path");
      request.files.add(imagePart);
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      Navigator.pop(context);
      print('Account updated successfully');
    } else {
      print('Failed to update account: ${response.statusCode}');
    }
  }

  String? imagePath;
  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Eddit Account")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Consumer(builder: (context, WidgetRef ref, _) {
              final date =
                  ref.watch(accountDataProvider(widget.accountUsername));
              date.when(
                  data: (data) {
                    // setState(() {
                    //   _username.text = data?.username ?? "";
                    //   _password.text = data?.password ?? "";
                    //   _name.text = data?.name ?? "";
                    // });
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () {});

              return Column(
                children: [
                  PickImage(
                    onImagePathSelected: (inagePath) async {
                      imagePath = inagePath;

                      print("path paici vai $imagePath");
                    },
                  ),
                  //.. Username ..//

                  ////////
                  CustomTextField(
                    controller: _name,
                    labelText: "Full Name",
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _username,
                    labelText: "username",
                  ),

                  const SizedBox(height: 20),
                  // CustomTextField(
                  //   controller: _password,
                  //   labelText: "Password",
                  // ),
                  //
                  //   const SizedBox(height: 20),
                  // CustomTextField(
                  //   controller: _confromPassword,
                  //   labelText: "Comfrom the password",
                  // ),
                  CupertinoButton(
                      color: Colors.blue,
                      child: const Text('Eddit Account'),
                      onPressed: () async {
                        await updateAccount(context,
                            name: _name.text, imagePath: imagePath);
                      }),
                  //
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
