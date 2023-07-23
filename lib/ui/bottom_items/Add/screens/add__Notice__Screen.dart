// ignore_for_file: unused_result, must_be_immutable, unnecessary_null_comparison

import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/component/responsive.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/widgets/appWidget/TextFromFild.dart';
import 'package:classmate/widgets/heder/heder_title.dart';

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../Home/notice_board/notice controller/virew_recent_notice_controller.dart';
import '../../Home/notice_board/request/motice_request.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';
import '../widgets/uploaded_pdf_button.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

final addNoticeLoaderProvider = StateProvider<bool>((ref) => false);

class AddNoticeScreen extends ConsumerWidget {
  // ignore: use_key_in_widget_constructors
  AddNoticeScreen({Key? key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  String? id;
  final _appBar = const CustomTitleBar("title");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final pdfPath = ref.watch(selectedPdfPathProvider);

    return SafeArea(
      child: Scaffold(
        body: Responsive(
          // Mobile
          mobile: Scaffold(
            body: _mobile(context, ref, pdfPath),
          ),

          // Desktop
          desktop: Scaffold(
            body: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: MyDrawer(),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _appBar,
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          child: _mobile(context, ref, pdfPath),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobile(BuildContext context, WidgetRef ref, String? pdfPath) {
    //
    final isLoading = ref.watch(addNoticeLoaderProvider);
    final isLoadingNotifier = ref.watch(addNoticeLoaderProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 400),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isMobile(context))
              HeaderTitle("Back to Home", context),
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Add A New \nNotice",
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      fontSize: 48.0,
                      height: 65 / 48, // This sets the line height to 65px
                      color: Colors.black,
                    ),
                  ),
                  // SelectNoticeBoardDropDowen(
                  //   onSelected: (iD) {
                  //     print(iD);
                  //     id = iD;
                  //   },
                  // ),
                  const SizedBox(height: 20),

                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: noticeTitleController,
                    hint: "Notice Title",
                    labelText: "Enter Your notice title",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter notice title';
                      }
                      if (value.trim().length > 25) {
                        return 'Notice title cannot exceed 25 words';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: descriptionController,
                    hint: "Notice Description",
                    labelText: "Describe what the notice is about.",
                  ).multiline(),
                  const SizedBox(height: 60),
                  UploadPDFBButton(onSelected: (thePath) {}),
                  // SizedBox(height: 200, width: 400, child: drag'sSelectFile()),
                  const SizedBox(height: 60),
                  CupertinoButtonCustom(
                    icon: Icons.check,
                    isLoading: isLoading,
                    color: AppColor.nokiaBlue,
                    text: "Add Notice",
                    onPressed: () async {
                      print("pdf path : $pdfPath");

                      if (_formKey.currentState!.validate()) {
                        File thePdf = File(pdfPath!);
                        String? mineType = lookupMimeType(pdfPath);
                        if (pdfPath == null) {
                          Alert.errorAlertDialog(context, "select pdf");
                        }
                        //
                        else if (mineType != 'application/pdf') {
                          return Alert.errorAlertDialog(
                              context, 'Only PDF file is allow');
                        } else if (thePdf.lengthSync() > 10 * 1024 * 1024) {
                          // Check file size in bytes (10 MB = 10 * 1024 * 1024 bytes)
                          return Alert.errorAlertDialog(
                            context,
                            'Maximum file size allowed is 10 MB',
                          );
                        } else {
                          isLoadingNotifier.update((state) => true);
                          return addNotice(
                            context,
                            pdfPath,
                            ref,
                            isLoadingNotifier,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addNotice(
      context, String pdfPath, WidgetRef ref, isLoadingNotifier) async {
    Either<String, String> res = await NoticeRequest().addNotice(
      contentName: noticeTitleController.text,
      description: descriptionController.text,
      pdfFile: pdfPath,
      ref: ref,
    );
    res.fold((l) {
      isLoadingNotifier.update((state) => false);

      return Alert.errorAlertDialog(context, l);
    }, (r) {
      ref.refresh(recentNoticeController(null));

      Navigator.pop(context);
      isLoadingNotifier.update((state) => false);

      return Alert.showSnackBar(context, r);
    });
  }
}

///

class DragsSelectFile extends ConsumerWidget {
  DragsSelectFile({super.key});

  late DropzoneViewController controller1;

  Future<void> acceptFile(dynamic event, WidgetRef ref) async {
    try {
      final mime = await controller1.getFileMIME(event);
      final byte = await controller1.getFileSize(event);
      final url = await controller1.createFileUrl(event);

      print('Mime: $mime');
      print('Size : ${byte / (1024 * 1024)}');
      print('URL: $url');
      //ref.watch(selectedPdfPathProvider.notifier).update((state) => url);
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: DropzoneView(
                  // ignore: unnecessary_this
                  onCreated: (controller) => this.controller1 = controller,
                  onDrop: (value) => acceptFile(value, ref),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    final events = await controller1.pickFiles();

                    print("events: $events");
                    acceptFile(events[0], ref);
                  } catch (e) {
                    print("Error: $e");
                  }
                },
                child: const Text("Drop file here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
