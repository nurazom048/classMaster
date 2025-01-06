import 'dart:io';

import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/socket%20services/socketCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/Summary%20Controller/summary_controller.dart';
import 'package:classmate/widgets/heder/heder_title.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mime/mime.dart';
import '../../../../../../constant/app_color.dart';
import '../../../../../../helper/helper_fun.dart';
import '../../../../../../widgets/appWidget/app_text.dart';
import '../../../../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final loaderProvider = StateProvider<bool>((ref) => false);

class AddSummaryScreen extends ConsumerStatefulWidget {
  const AddSummaryScreen(
      {Key? key, required this.classId, required this.routineId})
      : super(key: key);

  final String classId;
  final String routineId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSummaryScreenState();
}

final _summaryController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

Map<String, dynamic>? newMessage;
List<String> imageLinks = [];

class _AddSummaryScreenState extends ConsumerState<AddSummaryScreen> {
  @override
  void initState() {
    super.initState();
    SocketService.initializeSocket().then((_) {
      setState(() {
        print('Socket initialized.');
      });
    }).catchError((error) {
      print('Error initializing socket: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle("Back", context),
              const SizedBox(height: 30),
              Text('  Write Summary', style: TS.heading(fontSize: 36)),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Consumer(builder: (context, ref, _) {
                  final addSummary = ref
                      .read(summaryControllerProvider(widget.classId).notifier);
                  final isLoading = ref.watch(loaderProvider);

                  return Form(
                    key: formKey,
                    child: Column(
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
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter the summary';
                            }
                            return null;
                          },
                        ),
                        Container(
                          constraints: const BoxConstraints(
                              minHeight: 0, maxHeight: 100),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageLinks.length,
                            itemBuilder: (context, index) => Container(
                              alignment: Alignment.centerLeft,
                              width: 130,
                              height: 130,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: badges.Badge(
                                onTap: () {
                                  setState(() {
                                    imageLinks.removeAt(index);
                                  });
                                },
                                badgeContent: const Icon(Icons.close),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(imageLinks[index])),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            List<String>? imagelink =
                                await Multiple.pickAndCompressMultipleImages();

                            if (imagelink != null) {
                              setState(() {
                                imageLinks.addAll(imagelink);
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                        // Spacer(),
                        if (isLoading == true)
                          Loaders.center(height: 50)
                        else
                          CupertinoButtonCustom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: AppColor.nokiaBlue,
                            text: "Add Summary Now",
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                checkedFileType(imageLinks);
                                checkedMaxUploadLimit(
                                    imageLinks, ref, addSummary);
                              } else {
                                Alert.showSnackBar(context, 'Enter the form');
                              }
                            },
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkedFileType(List<String> imageLinks) {
    for (int i = 0; i < imageLinks.length; i++) {
      File theFile = File(imageLinks[i]);
      String? mineType = lookupMimeType(imageLinks[i]);

      if (mineType != 'image/jpeg' && mineType != 'image/png') {
        return Alert.errorAlertDialog(
          context,
          'Only [image/jpeg, image/png] allowed',
        );
      } else if (theFile.lengthSync() > 10 * 1024 * 1024) {
        // Check file size in bytes (10 MB = 10 * 1024 * 1024 bytes)
        return Alert.errorAlertDialog(
          context,
          'Maximum file size allowed is 10 MB',
        );
      }
    }
  }

  void checkedMaxUploadLimit(
    List<String> imageLinks,
    ref,
    SummaryController addSummary,
  ) {
    if (imageLinks.length > 9) {
      Alert.errorAlertDialog(
        context,
        'Maximum file limit allowed is 10',
      );
      return;
    }

    try {
      addSummary.addSummary(
        routineId: widget.routineId,
        ref,
        context,
        classId: widget.classId,
        message: _summaryController.text,
        imageLinks: imageLinks,
        checkedType: true,
      );
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
