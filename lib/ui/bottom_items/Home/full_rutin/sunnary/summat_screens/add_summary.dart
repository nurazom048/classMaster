import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/sunnary%20Controller/summary_controller.dart';
import 'package:table/widgets/TopBar.dart';

class AddSummaryScreen extends StatelessWidget {
  String classId;
  AddSummaryScreen({super.key, required this.classId});

  final _summaryController = TextEditingController();

//
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomTopBar("Add Summary"),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer(builder: (context, ref, _) {
                return Column(
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
                        child: const Text('Create'),
                        onPressed: () {
                          ref
                              .read(sunnaryControllerProvider(classId).notifier)
                              .addSummary(ref, classId, _summaryController.text,
                                  context);
                        }),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
