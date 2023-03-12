// ignore_for_file: unused_element, non_constant_identifier_names, avoid_print, prefer_final_fields, prefer_const_constructors_in_immutables, prefer_const_declarations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/models/Account_models.dart';
import 'dart:convert';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';

class AddCap10sPage extends StatefulWidget {
  AddCap10sPage({super.key, required this.rutinId});

  final String rutinId;

  @override
  State<AddCap10sPage> createState() => _AddCap10sPageState();
}

class _AddCap10sPageState extends State<AddCap10sPage> {
  TextEditingController _textController = TextEditingController();

  var _currentPage = 1;
  var _totalPages = 1;
  var _accounts = [];
  var username;

  void _searchAccounts() async {
    final limit = 10;
    final url = Uri.parse(
        'http://192.168.31.229:3000/account/accounts/find?username=$username&page=$_currentPage&limit=$limit');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      setState(() {
        _accounts = body['accounts'];
        _totalPages = body['totalPages'];
      });
    } else {
      throw Exception('Failed to search accounts.');
    }
  }

  ///
  ///
  void _addCaptens({username, position}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final url = Uri.parse('http://192.168.31.229:3000/rutin/cap10/add');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $getToken'
    }, body: {
      "rutinid": widget.rutinId,
      "position": position ?? "ist cap 10 ",
      "username": username
    });

    try {
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Alart.errorAlartDilog(context, res["message"]);
      } else {
        Alart.errorAlartDilog(context, res["message"]);
      }
    } catch (e) {
      Alart.errorAlartDilog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Captens")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            search(),
            accountsList(),
            pagination(),
          ],
        ),
      ),
    );
  }

  CupertinoNavigationBar search() => CupertinoNavigationBar(
        middle: CupertinoTextField(
          placeholder: 'Search',
          onChanged: (valu) {
            setState(() {
              username = valu;
            });
            _searchAccounts();
          },
          clearButtonMode: OverlayVisibilityMode.editing,
          style: const TextStyle(fontSize: 16),
          cursorColor: CupertinoColors.activeBlue,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            border: Border.all(
              color: CupertinoColors.inactiveGray,
              width: 0.5,
            ),
          ),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(CupertinoIcons.search, size: 18.0),
          ),
          suffix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Text('Search'),
          ),
        ),
      );

  Widget accountsList() {
    if (_accounts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No accounts found.'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _accounts.length,
        itemBuilder: (BuildContext context, int index) {
          final account = AccountModels.fromJson(_accounts[index]);

          //
          return AccountCardRow(
            accountData: account,
            suffix: TextButton(
                child: const Text("Add Cap10"),
                onPressed: () =>
                    alart_Add_Cap10s(context, account.username.toString())),
          );
        },
      );
    }
  }

  Widget pagination() {
    if (_totalPages <= 1) {
      return const SizedBox.shrink();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            onPressed: () {
              if (_currentPage > 1) {
                setState(() {
                  _currentPage--;
                });
                _searchAccounts();
              }
            },
            child: const Icon(CupertinoIcons.chevron_left),
          ),
          Text('$_currentPage / $_totalPages'),
          CupertinoButton(
            onPressed: () {
              if (_currentPage < _totalPages) {
                setState(() {
                  _currentPage++;
                });
                _searchAccounts();
              }
            },
            child: const Icon(CupertinoIcons.chevron_right),
          ),
        ],
      );
    }
  }

  alart_Add_Cap10s(context, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Capten',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Enter position'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                String caption = _textController.text;
                _addCaptens(position: caption, username: username);
                Navigator.of(context).pop();
              },
            ),
          ],
          // Add any desired styles here
          // ...
        );
      },
    );
  }
}
