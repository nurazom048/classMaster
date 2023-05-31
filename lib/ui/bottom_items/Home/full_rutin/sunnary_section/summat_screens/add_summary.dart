import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/sunnary%20Controller/summary_controller.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../../../helper/helper_fun.dart';
import '../../../../../../widgets/appWidget/app_text.dart';

class AddSummaryScreen extends ConsumerStatefulWidget {
  const AddSummaryScreen({super.key, required this.classId});

  final String classId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSummaryScreenState();
}

//
final _summaryController = TextEditingController();
Map<String, dynamic>? newMessage;

//
List<String> imageLinks = [];

class _AddSummaryScreenState extends ConsumerState<AddSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle("", context),
              const SizedBox(height: 30),
              const AppText('  Write Summary').title(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Consumer(builder: (context, ref, _) {
                  //! provider
                  final addSummary = ref
                      .read(sunnaryControllerProvider(widget.classId).notifier);

                  return Column(
                    children: [
                      TextFormField(
                        controller: _summaryController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write Summary',
                          hintStyle: TextStyle(
                            fontFamily: 'Open Sans',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            height: 1.27,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.blueAccent,
                        constraints:
                            const BoxConstraints(minHeight: 0, maxHeight: 100),

                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageLinks.length,
                          itemBuilder: (context, index) => Container(
                              alignment: Alignment.centerLeft,
                              width: 100,
                              height: 100,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.rectangle,
                              ),
                              child: Image(
                                  image: FileImage(File(imageLinks[index])))),
                        ),
                      ),

                      // pick image
                      IconButton(
                          onPressed: () async {
                            String? imagelink =
                                await HelperMethods.pickAndCompressImage();

                            setState(() {
                              imageLinks.add(imagelink!);
                            });
                          },
                          icon: const Icon(Icons.add)),
                      const SizedBox(height: 20),

                      // create button
                      CupertinoButton(
                          color: Colors.blue,
                          child: const ma.Text('Create'),
                          onPressed: () async {
                            newMessage = {
                              'name': 'John Doe new',
                              'messaage': _summaryController.text,
                              'imageLinks': imageLinks
                            };

                            // add summary
                            addSummary.addSummarys(ref, context,
                                _summaryController.text, imageLinks);

                            // print(newMessage.toString());
                          }),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
