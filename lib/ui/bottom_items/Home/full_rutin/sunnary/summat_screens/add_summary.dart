import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_request/summary_request.dart';
import 'package:table/widgets/heder/hederTitle.dart';

import '../../../../../../helper/helper_fun.dart';
import '../../../../../../widgets/appWidget/appText.dart';

class AddSummaryScreen extends ConsumerStatefulWidget {
  const AddSummaryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSummaryScreenState();
}

//
final _summaryController = TextEditingController();
Map<String, dynamic>? newMessage;
List<String> imageLinks = [
  //  'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80',
  // 'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80'
];

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
                  //

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
                            BoxConstraints(minHeight: 0, maxHeight: 100),

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

                            if (imageLinks != null) {
                              print("not null");

                              setState(() {
                                imageLinks.add(imagelink!);
                              });
                            }
                          },
                          icon: Icon(Icons.add)),
                      const SizedBox(height: 20),

                      // create button
                      CupertinoButton(
                          color: Colors.blue,
                          child: const Text('Create'),
                          onPressed: () async {
                            newMessage = {
                              'name': 'John Doe new',
                              'messaage': _summaryController.text,
                              'imageLinks': imageLinks
                            };

                            Either<Message, Message> res =
                                await SummayReuest.addSummaryRequest(
                                    'John Doe new', imageLinks);

                            //
                            res.fold(
                                (error) => Alart.errorAlartDilog(
                                    context, error.message),
                                (r) => Alart.showSnackBar(context, r.message));

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



// class AddSummaryScreen extends StatefulWidget {
//   AddSummaryScreen({
//     super.key,
//   });

//   @override
//   State<AddSummaryScreen> createState() => _AddSummaryScreenState();
// }

// class _AddSummaryScreenState extends State<AddSummaryScreen> {
//   final _summaryController = TextEditingController();

//   Map<String, dynamic>? newMessage;

//   List<String> imageLinks = [
//     //  'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80',
//     // 'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80'
//   ];
// //
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child:
//     );
//   }
// }
// // ref
// //     .read(sunnaryControllerProvider(classId).notifier)
// //     .addSummary(ref, classId, _summaryController.text,
// //         context);
