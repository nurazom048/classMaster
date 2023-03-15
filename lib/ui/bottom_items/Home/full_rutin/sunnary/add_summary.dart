import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/widgets/TopBar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddSummaryScreen extends StatefulWidget {
  String classId;
  AddSummaryScreen({super.key, required this.classId});

  @override
  State<AddSummaryScreen> createState() => _AddSummaryScreenState();
}

class _AddSummaryScreenState extends State<AddSummaryScreen> {
  final _summaryController = TextEditingController();
//
  String? message;
  String base = "192.168.0.125:3000";
  //String base = "192.168.0.125:3000";
  // String base = "localhost:3000";

  Future<void> addSummary(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');
    try {
      //... send request

      final response = await http.post(
        Uri.parse('http://$base/summary/add/${widget.classId}'),
        headers: {'Authorization': 'Bearer $getToken'},
        body: {"text": _summaryController.text},
      );

      if (response.statusCode == 200) {
        message = "Summay added sucsesfull";
        Navigator.pop(context);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomTopBar("Add Summary"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _summaryController,
                    decoration: const InputDecoration(
                      hintText: 'Summary',
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    color: Colors.blue,
                    child: const Text('Login'),
                    onPressed: () {
                      addSummary(context);

                      //
                      if (message != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(message!)));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
